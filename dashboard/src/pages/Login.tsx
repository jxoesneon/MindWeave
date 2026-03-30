import { useState, memo } from 'react'
import { useAuth } from '../hooks/useAuth'
import { supabase } from '../lib/supabase'
import { showSuccess } from '../lib/toast'

export const Login = memo(function Login() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [mfaCode, setMfaCode] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const [mfaRequired, setMfaRequired] = useState(false)
  const [factorId, setFactorId] = useState<string | null>(null)
  const { signIn } = useAuth()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError('')

    const { error } = await signIn(email, password)
    
    // Debug logging
    console.log('Login error:', error)
    console.log('Error message:', error?.message)
    console.log('Error code:', (error as { code?: string })?.code)
    
    if (error) {
      // Check if MFA is required - be more lenient with detection
      const errorMsg = error.message?.toLowerCase() || ''
      const errorCode = (error as { code?: string })?.code
      
      if (errorMsg.includes('mfa') || 
          errorMsg.includes('two-factor') ||
          errorMsg.includes('2fa') ||
          errorMsg.includes('totp') ||
          errorMsg.includes('challenge') ||
          errorMsg.includes('aamr') ||
          errorCode === 'mfa_challenge' ||
          errorCode === 'aamr_not_verified') {
        // MFA is required - need to get factors and show MFA input
        console.log('MFA required detected, fetching factors...')
        const { data: factorsData, error: factorsError } = await supabase.auth.mfa.listFactors()
        console.log('Factors data:', factorsData)
        console.log('Factors error:', factorsError)
        
        const totpFactor = factorsData?.all?.find((f: { factor_type: string }) => f.factor_type === 'totp')
        
        if (totpFactor) {
          setFactorId(totpFactor.id)
          setMfaRequired(true)
          setError('')
        } else {
          setError('MFA required but no TOTP factor found')
        }
      } else {
        setError(error.message)
      }
    }
    
    setLoading(false)
  }

  const handleMFAVerify = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!factorId) return
    
    setLoading(true)
    setError('')
    
    try {
      // Create challenge
      const { data: challengeData, error: challengeError } = await supabase.auth.mfa.challenge({
        factorId
      })
      
      if (challengeError) throw challengeError
      
      // Verify
      const { error: verifyError } = await supabase.auth.mfa.verify({
        factorId,
        challengeId: challengeData.id,
        code: mfaCode
      })
      
      if (verifyError) throw verifyError
      
      showSuccess('MFA verified successfully')
      // Reload to trigger auth state check
      window.location.reload()
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Invalid MFA code')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-4">
      <div className="w-full max-w-md bg-surface rounded-lg p-8 border border-gray-800">
        <div className="text-center mb-8">
          <h1 className="text-2xl font-bold text-white mb-2">MindWeave Admin</h1>
          <p className="text-text-secondary">Sign in to access the dashboard</p>
        </div>

        {mfaRequired ? (
          <form onSubmit={handleMFAVerify} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-text-secondary mb-1">
                Two-Factor Authentication Code
              </label>
              <input
                type="text"
                value={mfaCode}
                onChange={(e) => setMfaCode(e.target.value)}
                placeholder="Enter 6-digit code"
                className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary"
                required
                autoComplete="one-time-code"
                maxLength={6}
              />
              <p className="mt-2 text-sm text-text-secondary">
                Enter the code from your authenticator app
              </p>
            </div>

            {error && (
              <div className="text-red-400 text-sm">{error}</div>
            )}

            <div className="flex space-x-3">
              <button
                type="button"
                onClick={() => setMfaRequired(false)}
                className="flex-1 py-2 px-4 bg-background border border-gray-700 text-white rounded-md font-medium transition-colors"
              >
                Back
              </button>
              <button
                type="submit"
                disabled={loading || mfaCode.length !== 6}
                className="flex-1 py-2 px-4 bg-primary hover:bg-opacity-90 text-white rounded-md font-medium transition-colors disabled:opacity-50"
              >
                {loading ? 'Verifying...' : 'Verify'}
              </button>
            </div>
          </form>
        ) : (
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-text-secondary mb-1">
                Email
              </label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary"
                required
                autoComplete="email"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-text-secondary mb-1">
                Password
              </label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary"
                required
                autoComplete="current-password"
              />
            </div>

            {error && (
              <div className="text-red-400 text-sm">{error}</div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full py-2 px-4 bg-primary hover:bg-opacity-90 text-white rounded-md font-medium transition-colors disabled:opacity-50"
            >
              {loading ? 'Signing in...' : 'Sign In'}
            </button>
          </form>
        )}
      </div>
    </div>
  )
})
