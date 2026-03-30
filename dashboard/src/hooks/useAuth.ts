import { useState, useEffect, useCallback } from 'react'
import { supabase } from '../lib/supabase'
import { reportError } from '../lib/errorReporter'
import type { User, AuthError } from '@supabase/supabase-js'

// Auth hook with comprehensive error handling and logging - v5 (gated)

const DEBUG_AUTH = false // Toggle this to enable verbose auth logging

interface AuthLog {
  timestamp: string
  action: string
  details: Record<string, unknown>
  error?: string
}

function logAuth(action: string, details: Record<string, unknown> = {}, error?: AuthError | Error | unknown): AuthLog | null {
  const log: AuthLog = {
    timestamp: new Date().toISOString(),
    action,
    details: { ...details, userAgent: navigator.userAgent.slice(0, 50) }
  }
  if (error) {
    log.error = error instanceof Error ? error.message : String(error)
  }
  if (DEBUG_AUTH || error) {
    console.log('[Auth]', log)
  }
  return DEBUG_AUTH || error ? log : null
}

export function useAuth() {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)
  const [isAdmin, setIsAdmin] = useState(false)
  const [isViewer, setIsViewer] = useState(false)
  const [authError, setAuthError] = useState<string | null>(null)

  // Check admin status with full logging
  const checkAdminStatus = useCallback(async (userId: string): Promise<boolean> => {
    logAuth('check_admin_start', { userId: userId.slice(0, 8) + '...' })
    
    try {
      const { data: adminData, error: adminError } = await supabase
        .rpc('check_is_admin', { user_id: userId })
      
      if (adminError) {
        logAuth('check_admin_error', { 
          userId: userId.slice(0, 8) + '...',
          code: adminError.code,
          message: adminError.message
        }, adminError)
        
        // Handle JWT errors specifically
        if (adminError.message?.includes('JWT') || 
            adminError.message?.includes('token') ||
            adminError.code === 'PGRST301') {
          logAuth('jwt_invalid_signing_out', { userId: userId.slice(0, 8) + '...' })
          await supabase.auth.signOut()
          setUser(null)
          return false
        }
        
        return false
      }
      
      const isUserAdmin = !!adminData
      logAuth('check_admin_success', { 
        userId: userId.slice(0, 8) + '...',
        isAdmin: isUserAdmin 
      })
      return isUserAdmin
    } catch (err) {
      logAuth('check_admin_exception', { userId: userId.slice(0, 8) + '...' }, err)
      reportError(err, 'useAuth.checkAdminStatus')
      return false
    }
  }, [])

  // Check viewer status with logging
  const checkViewerStatus = useCallback(async (userId: string): Promise<boolean> => {
    logAuth('check_viewer_start', { userId: userId.slice(0, 8) + '...' })
    
    try {
      const { data: viewerData, error: viewerError } = await supabase
        .from('user_roles')
        .select('role')
        .eq('user_id', userId)
        .eq('role', 'viewer')
        .maybeSingle()
      
      if (viewerError) {
        logAuth('check_viewer_error', { userId: userId.slice(0, 8) + '...' }, viewerError)
        return false
      }
      
      const isUserViewer = !!viewerData
      logAuth('check_viewer_success', { 
        userId: userId.slice(0, 8) + '...',
        isViewer: isUserViewer 
      })
      return isUserViewer
    } catch (err) {
      logAuth('check_viewer_exception', { userId: userId.slice(0, 8) + '...' }, err)
      return false
    }
  }, [])

  useEffect(() => {
    let timeoutId: ReturnType<typeof setTimeout>
    let heartbeatId: ReturnType<typeof setInterval>
    let isMounted = true
    let authCompleted = false
    
    const getSession = async () => {
      logAuth('get_session_start')
      setAuthError(null)
      
      // Safety timeout - force loading false after 8 seconds max
      logAuth('timeout_set', { timeoutMs: 8000 })
      timeoutId = setTimeout(() => {
        logAuth('timeout_fired', { isMounted, authCompleted, timestamp: new Date().toISOString() })
        if (isMounted && !authCompleted) {
          logAuth('timeout_triggering_error', { reason: 'mounted and not completed' })
          setAuthError('Session check timed out - please refresh')
          setLoading(false)
        } else {
          logAuth('timeout_skipped', { reason: isMounted ? 'auth already completed' : 'component unmounted' })
        }
      }, 8000)
      
      // Heartbeat to verify main thread isn't blocked
      let heartbeatCount = 0
      heartbeatId = setInterval(() => {
        heartbeatCount++
        logAuth('heartbeat', { count: heartbeatCount, isMounted, authCompleted })
      }, 1000)
      
      try {
        logAuth('supabase_get_session_call')
        const { data: { session }, error: sessionError } = await supabase.auth.getSession()
        
        if (!isMounted) {
          clearTimeout(timeoutId)
          return
        }
        
        if (sessionError) {
          logAuth('get_session_error', { 
            code: sessionError.code,
            message: sessionError.message 
          }, sessionError)
          
          await supabase.auth.signOut()
          setUser(null)
          setIsAdmin(false)
          setIsViewer(false)
          setAuthError(`Session error: ${sessionError.message}`)
          clearTimeout(timeoutId)
          authCompleted = true
          setLoading(false)
          return
        }
        
        logAuth('get_session_success', { 
          hasSession: !!session,
          userId: session?.user?.id?.slice(0, 8) + '...'
        })
        
        if (session?.user) {
          logAuth('user_found_setting_user')
          setUser(session.user)
          
          // Run both checks in parallel for speed
          logAuth('starting_role_checks', { userId: session.user.id.slice(0, 8) + '...' })
          const [adminResult, viewerResult] = await Promise.all([
            checkAdminStatus(session.user.id),
            checkViewerStatus(session.user.id)
          ])
          
          logAuth('role_checks_returned', { isMounted, adminResult, viewerResult })
          
          if (isMounted) {
            logAuth('setting_auth_completed_and_states')
            authCompleted = true
            setIsAdmin(adminResult)
            setIsViewer(viewerResult)
            logAuth('role_checks_complete', { 
              isAdmin: adminResult, 
              isViewer: viewerResult 
            })
          } else {
            logAuth('role_checks_returned_but_unmounted')
          }
        } else {
          logAuth('no_session_found')
          authCompleted = true
          setUser(null)
          setIsAdmin(false)
          setIsViewer(false)
        }
      } catch (err) {
        logAuth('get_session_exception', {}, err)
        reportError(err, 'useAuth.getSession')
        
        if (isMounted) {
          setUser(null)
          setIsAdmin(false)
          setIsViewer(false)
          setAuthError(`Auth error: ${err instanceof Error ? err.message : 'Unknown error'}`)
        }
      } finally {
        if (isMounted) {
          clearTimeout(timeoutId)
          setLoading(false)
          logAuth('get_session_complete', { loading: false, authCompleted })
        }
      }
    }

    getSession()

    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        logAuth('auth_state_change', { 
          event, 
          hasSession: !!session,
          userId: session?.user?.id?.slice(0, 8) + '...'
        })
        
        if (!isMounted) return
        
        setUser(session?.user ?? null)
        
        if (session?.user) {
          const [adminResult, viewerResult] = await Promise.all([
            checkAdminStatus(session.user.id),
            checkViewerStatus(session.user.id)
          ])
          
          if (isMounted) {
            authCompleted = true
            setIsAdmin(adminResult)
            setIsViewer(viewerResult)
          }
        } else {
          authCompleted = true
          setIsAdmin(false)
          setIsViewer(false)
        }
        setLoading(false)
      }
    )

    return () => {
      isMounted = false
      clearTimeout(timeoutId)
      clearInterval(heartbeatId)
      subscription.unsubscribe()
    }
  }, [checkAdminStatus, checkViewerStatus])

  const signIn = async (email: string, password: string) => {
    logAuth('sign_in_attempt', { email: email.slice(0, 3) + '***' })
    
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    })
    
    if (error) {
      logAuth('sign_in_error', { email: email.slice(0, 3) + '***' }, error)
    } else {
      logAuth('sign_in_success', { 
        email: email.slice(0, 3) + '***',
        userId: data.user?.id?.slice(0, 8) + '...'
      })
    }
    
    return { error, data }
  }

  const signOut = async () => {
    logAuth('sign_out_attempt', { userId: user?.id?.slice(0, 8) + '...' })
    
    const { error } = await supabase.auth.signOut()
    
    if (error) {
      logAuth('sign_out_error', {}, error)
    } else {
      logAuth('sign_out_success')
      setUser(null)
      setIsAdmin(false)
      setIsViewer(false)
    }
    
    return { error }
  }

  return {
    user,
    loading,
    isAdmin,
    isViewer,
    authError,
    signIn,
    signOut,
  }
}
