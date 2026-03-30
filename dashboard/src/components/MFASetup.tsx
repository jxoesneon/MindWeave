import { useState, memo, useEffect } from 'react'
import { supabase } from '../lib/supabase'
import { Shield, Lock, Copy, CheckCircle, Trash2, Loader2 } from 'lucide-react'
import { showSuccess, showError } from '../lib/toast'

interface MFAFactor {
  id: string
  status: 'verified' | 'unverified'
  type: 'totp'
}

export const MFASetup = memo(function MFASetup() {
  const [isEnabling, setIsEnabling] = useState(false)
  const [isDisabling, setIsDisabling] = useState(false)
  const [factorId, setFactorId] = useState<string | null>(null)
  const [totpSecret, setTotpSecret] = useState('')
  const [qrCode, setQrCode] = useState('')
  const [verifyCode, setVerifyCode] = useState('')
  const [loading, setLoading] = useState(false)
  const [factors, setFactors] = useState<MFAFactor[]>([])
  const [isChecking, setIsChecking] = useState(true)

  // Check existing MFA factors on mount
  useEffect(() => {
    checkExistingFactors()
  }, [])

  const checkExistingFactors = async () => {
    try {
      const { data, error } = await supabase.auth.mfa.listFactors()
      if (error) throw error
      
      // Get all TOTP factors (both verified and unverified)
      const allFactors = data?.all?.filter((f: { factor_type: string }) => f.factor_type === 'totp') || []
      setFactors(allFactors.map((f: { id: string; status: string }) => ({ 
        id: f.id, 
        status: f.status as 'verified' | 'unverified',
        type: 'totp'
      })))
    } catch (err) {
      console.error('Failed to check MFA factors:', err)
    } finally {
      setIsChecking(false)
    }
  }

  const hasVerifiedFactor = factors.some((f: MFAFactor) => f.status === 'verified')
  const hasUnverifiedFactor = factors.some((f: MFAFactor) => f.status === 'unverified')

  // Unenroll unverified factor (no AAL2 required)
  const unenrollUnverified = async (id: string) => {
    try {
      setLoading(true)
      const { error } = await supabase.auth.mfa.unenroll({ factorId: id })
      if (error) throw error
      await checkExistingFactors()
    } catch (err) {
      console.error('Failed to unenroll:', err)
    } finally {
      setLoading(false)
    }
  }

  const startMFASetup = async () => {
    // If there's an unverified factor, unenroll it first to avoid 422 error
    if (hasUnverifiedFactor) {
      const unverifiedFactor = factors.find((f: MFAFactor) => f.status === 'unverified')
      if (unverifiedFactor) {
        await unenrollUnverified(unverifiedFactor.id)
      }
    }

    try {
      setLoading(true)
      setIsEnabling(true)
      
      const { data, error } = await supabase.auth.mfa.enroll({
        factorType: 'totp',
      })

      if (error) throw error

      setFactorId(data.id)
      setTotpSecret(data.totp.secret)
      setQrCode(data.totp.uri)
    } catch (err) {
      showError(err instanceof Error ? err.message : 'Failed to start MFA setup')
      setIsEnabling(false)
    } finally {
      setLoading(false)
    }
  }

  const startDisabling = async () => {
    const factor = factors.find((f: MFAFactor) => f.status === 'verified')
    if (!factor) return
    
    setFactorId(factor.id)
    setIsDisabling(true)
    setVerifyCode('')
  }

  const confirmDisable = async () => {
    if (!factorId) return

    try {
      setLoading(true)
      
      // First create a challenge
      const { data: challengeData, error: challengeError } = await supabase.auth.mfa.challenge({
        factorId
      })
      if (challengeError) throw challengeError

      // Verify the challenge
      const { error: verifyError } = await supabase.auth.mfa.verify({
        factorId,
        challengeId: challengeData.id,
        code: verifyCode
      })
      if (verifyError) throw verifyError

      // Now unenroll (AAL2 satisfied)
      const { error } = await supabase.auth.mfa.unenroll({ factorId })
      if (error) throw error
      
      showSuccess('MFA removed successfully')
      setIsDisabling(false)
      setFactorId(null)
      setVerifyCode('')
      await checkExistingFactors()
    } catch (err) {
      showError(err instanceof Error ? err.message : 'Failed to remove MFA')
    } finally {
      setLoading(false)
    }
  }

  const verifyAndEnable = async () => {
    if (!factorId) return

    try {
      setLoading(true)
      
      const { error } = await supabase.auth.mfa.challengeAndVerify({
        factorId,
        code: verifyCode,
      })

      if (error) throw error

      showSuccess('MFA enabled successfully!')
      await checkExistingFactors()
      setIsEnabling(false)
      setVerifyCode('')
    } catch (err) {
      showError(err instanceof Error ? err.message : 'Invalid verification code')
    } finally {
      setLoading(false)
    }
  }

  if (isChecking) {
    return (
      <div className="bg-surface rounded-lg p-6 border border-gray-800">
        <div className="flex items-center mb-4">
          <Shield className="w-6 h-6 text-primary mr-3" />
          <h2 className="text-lg font-semibold text-white">Two-Factor Authentication</h2>
        </div>
        <div className="flex items-center text-text-secondary">
          <Loader2 className="w-5 h-5 mr-2 animate-spin" />
          <span>Checking MFA status...</span>
        </div>
      </div>
    )
  }

  if (hasVerifiedFactor) {
    return (
      <div className="bg-surface rounded-lg p-6 border border-gray-800">
        <div className="flex items-center mb-4">
          <Shield className="w-6 h-6 text-green-400 mr-3" />
          <h2 className="text-lg font-semibold text-white">Two-Factor Authentication</h2>
        </div>
        
        {isDisabling ? (
          <div className="space-y-4">
            <p className="text-text-secondary">
              Enter your authenticator code to confirm disabling MFA:
            </p>
            <div>
              <label className="block text-sm font-medium text-text-secondary mb-1">
                Verification Code
              </label>
              <input
                type="text"
                value={verifyCode}
                onChange={(e) => setVerifyCode(e.target.value)}
                placeholder="Enter 6-digit code"
                className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary"
              />
            </div>
            <div className="flex space-x-3">
              <button
                onClick={() => setIsDisabling(false)}
                className="flex-1 px-4 py-2 bg-background border border-gray-700 text-white rounded-lg hover:bg-gray-800 transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={confirmDisable}
                disabled={loading || verifyCode.length !== 6}
                className="flex-1 px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors disabled:opacity-50"
              >
                {loading ? 'Verifying...' : 'Confirm Disable'}
              </button>
            </div>
          </div>
        ) : (
          <div className="flex items-center justify-between">
            <div className="flex items-center text-green-400">
              <CheckCircle className="w-5 h-5 mr-2" />
              <span>MFA is enabled on your account</span>
            </div>
            <button
              onClick={startDisabling}
              disabled={loading}
              className="flex items-center px-3 py-2 bg-red-500/20 text-red-400 rounded-lg hover:bg-red-500/30 transition-colors"
            >
              <Trash2 className="w-4 h-4 mr-2" />
              {loading ? 'Removing...' : 'Disable MFA'}
            </button>
          </div>
        )}
      </div>
    )
  }

  return (
    <div className="bg-surface rounded-lg p-6 border border-gray-800">
      <div className="flex items-center mb-4">
        <Shield className="w-6 h-6 text-primary mr-3" />
        <h2 className="text-lg font-semibold text-white">Two-Factor Authentication</h2>
      </div>

      {!isEnabling ? (
        <div>
          <p className="text-text-secondary mb-4">
            Add an extra layer of security to your account by enabling two-factor authentication.
          </p>
          <button
            onClick={startMFASetup}
            disabled={loading}
            className="flex items-center px-4 py-2 bg-primary text-white rounded-lg hover:bg-opacity-90 transition-colors"
          >
            <Lock className="w-4 h-4 mr-2" />
            {loading ? 'Setting up...' : 'Enable MFA'}
          </button>
        </div>
      ) : (
        <div className="space-y-4">
          <p className="text-text-secondary">
            Scan this QR code with your authenticator app:
          </p>
          
          {qrCode && (
            <div className="bg-white p-4 rounded-lg inline-block">
              <img 
                src={`https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${encodeURIComponent(qrCode)}`}
                alt="MFA QR Code"
                className="w-48 h-48"
              />
            </div>
          )}

          <div className="bg-background rounded p-3 flex items-center justify-between">
            <code className="text-sm text-white font-mono">{totpSecret}</code>
            <button
              onClick={() => {
                navigator.clipboard.writeText(totpSecret)
                showSuccess('Secret copied to clipboard')
              }}
              className="p-2 text-text-secondary hover:text-white transition-colors"
            >
              <Copy className="w-4 h-4" />
            </button>
          </div>

          <div>
            <label className="block text-sm font-medium text-text-secondary mb-1">
              Verification Code
            </label>
            <input
              type="text"
              value={verifyCode}
              onChange={(e) => setVerifyCode(e.target.value)}
              placeholder="Enter 6-digit code"
              className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary"
            />
          </div>

          <div className="flex space-x-3">
            <button
              onClick={() => setIsEnabling(false)}
              className="flex-1 px-4 py-2 bg-background border border-gray-700 text-white rounded-lg hover:bg-gray-800 transition-colors"
            >
              Cancel
            </button>
            <button
              onClick={verifyAndEnable}
              disabled={loading || verifyCode.length !== 6}
              className="flex-1 px-4 py-2 bg-primary text-white rounded-lg hover:bg-opacity-90 transition-colors disabled:opacity-50"
            >
              {loading ? 'Verifying...' : 'Verify & Enable'}
            </button>
          </div>
        </div>
      )}
    </div>
  )
})
