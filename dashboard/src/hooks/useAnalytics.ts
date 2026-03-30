import { useState, useEffect } from 'react'
import { supabase } from '../lib/supabase'
import type { DashboardStats, AnalyticsMetric, FrequencyBandStats } from '../types'

export function useAnalytics() {
  const [stats, setStats] = useState<DashboardStats>({
    totalUsers: 0,
    activeUsersToday: 0,
    activeUsersMonth: 0,
    totalSessions: 0,
    avgSessionDuration: 0,
    totalDonations: 0,
    donationAmount: 0,
  })
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    fetchStats()
  }, [])

  const fetchStats = async () => {
    try {
      setLoading(true)
      
      // Get total users
      const { count: totalUsers } = await supabase
        .from('users')
        .select('*', { count: 'exact', head: true })

      // Get active users today
      const today = new Date().toISOString().split('T')[0]
      const { count: activeUsersToday } = await supabase
        .from('sessions')
        .select('*', { count: 'exact', head: true })
        .gte('started_at', today)

      // Get active users this month
      const monthStart = new Date()
      monthStart.setDate(1)
      const { count: activeUsersMonth } = await supabase
        .from('sessions')
        .select('*', { count: 'exact', head: true })
        .gte('started_at', monthStart.toISOString())

      // Get total sessions
      const { count: totalSessions } = await supabase
        .from('sessions')
        .select('*', { count: 'exact', head: true })

      // Get average session duration
      const { data: sessionData } = await supabase
        .from('sessions')
        .select('duration_seconds')
        .not('duration_seconds', 'is', null)

      const avgSessionDuration = sessionData?.length
        ? sessionData.reduce((acc, s) => acc + (s.duration_seconds || 0), 0) / sessionData.length
        : 0

      // Get donation stats
      const { data: donationData } = await supabase
        .from('donations')
        .select('amount')

      const totalDonations = donationData?.length || 0
      const donationAmount = donationData?.reduce((acc, d) => acc + (d.amount || 0), 0) || 0

      setStats({
        totalUsers: totalUsers || 0,
        activeUsersToday: activeUsersToday || 0,
        activeUsersMonth: activeUsersMonth || 0,
        totalSessions: totalSessions || 0,
        avgSessionDuration: Math.round(avgSessionDuration / 60), // Convert to minutes
        totalDonations,
        donationAmount,
      })
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch stats')
    } finally {
      setLoading(false)
    }
  }

  return { stats, loading, error, refetch: fetchStats }
}

export function useDailyActiveUsers(days: number = 30) {
  const [data, setData] = useState<AnalyticsMetric[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchData = async () => {
      try {
        const startDate = new Date()
        startDate.setDate(startDate.getDate() - days)
        
        const { data: sessions } = await supabase
          .from('sessions')
          .select('started_at')
          .gte('started_at', startDate.toISOString())

        const dailyCounts: Record<string, number> = {}
        
        // Initialize all days with 0
        for (let i = 0; i < days; i++) {
          const d = new Date()
          d.setDate(d.getDate() - i)
          dailyCounts[d.toISOString().split('T')[0]] = 0
        }

        // Count sessions per day
        sessions?.forEach((session) => {
          const date = session.started_at.split('T')[0]
          if (dailyCounts[date] !== undefined) {
            dailyCounts[date]++
          }
        })

        const result = Object.entries(dailyCounts)
          .map(([date, value]) => ({ date, value }))
          .sort((a, b) => a.date.localeCompare(b.date))

        setData(result)
      } finally {
        setLoading(false)
      }
    }

    fetchData()
  }, [days])

  return { data, loading }
}

export function useMonthlyActiveUsers(months: number = 6) {
  const [data, setData] = useState<AnalyticsMetric[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchData = async () => {
      try {
        const startDate = new Date()
        startDate.setMonth(startDate.getMonth() - months)
        
        const { data: sessions } = await supabase
          .from('sessions')
          .select('started_at, user_id')
          .gte('started_at', startDate.toISOString())

        const monthlyCounts: Record<string, Set<string>> = {}
        
        // Initialize all months with empty sets
        for (let i = 0; i < months; i++) {
          const d = new Date()
          d.setMonth(d.getMonth() - i)
          const key = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`
          monthlyCounts[key] = new Set()
        }

        // Count unique users per month
        sessions?.forEach((session) => {
          const date = new Date(session.started_at)
          const key = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`
          if (monthlyCounts[key]) {
            monthlyCounts[key].add(session.user_id)
          }
        })

        const result = Object.entries(monthlyCounts)
          .map(([date, users]) => ({ date, value: users.size }))
          .sort((a, b) => a.date.localeCompare(b.date))

        setData(result)
      } finally {
        setLoading(false)
      }
    }

    fetchData()
  }, [months])

  return { data, loading }
}

export function useSessionDurationDistribution() {
  const [data, setData] = useState<{ range: string; count: number }[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchData = async () => {
      try {
        const { data: sessions } = await supabase
          .from('sessions')
          .select('duration_seconds')
          .not('duration_seconds', 'is', null)

        const ranges = {
          '< 5 min': 0,
          '5-15 min': 0,
          '15-30 min': 0,
          '30-60 min': 0,
          '> 60 min': 0,
        }

        sessions?.forEach((session) => {
          const mins = (session.duration_seconds || 0) / 60
          if (mins < 5) ranges['< 5 min']++
          else if (mins < 15) ranges['5-15 min']++
          else if (mins < 30) ranges['15-30 min']++
          else if (mins < 60) ranges['30-60 min']++
          else ranges['> 60 min']++
        })

        const result = Object.entries(ranges).map(([range, count]) => ({
          range,
          count,
        }))

        setData(result)
      } finally {
        setLoading(false)
      }
    }

    fetchData()
  }, [])

  return { data, loading }
}

export function useFrequencyBandStats() {
  const [data, setData] = useState<FrequencyBandStats[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchData = async () => {
      try {
        const { data: sessions } = await supabase
          .from('sessions')
          .select('beat_frequency')

        const bands: Record<string, number> = {
          Delta: 0,
          Theta: 0,
          Alpha: 0,
          Beta: 0,
          Gamma: 0,
        }

        sessions?.forEach((session) => {
          const freq = session.beat_frequency
          if (freq < 4) bands.Delta++
          else if (freq < 8) bands.Theta++
          else if (freq < 12) bands.Alpha++
          else if (freq < 30) bands.Beta++
          else bands.Gamma++
        })

        const total = sessions?.length || 1
        const result = Object.entries(bands).map(([band, count]) => ({
          band,
          count,
          percentage: Math.round((count / total) * 100),
        }))

        setData(result)
      } finally {
        setLoading(false)
      }
    }

    fetchData()
  }, [])

  return { data, loading }
}


export function useRealtimeUserCount() {
  const [count, setCount] = useState(0)

  useEffect(() => {
    const fetchCount = async () => {
      const fiveMinutesAgo = new Date(Date.now() - 5 * 60 * 1000).toISOString()
      const { count: activeCount } = await supabase
        .from('sessions')
        .select('*', { count: 'exact', head: true })
        .gte('started_at', fiveMinutesAgo)
        .is('ended_at', null)
      
      setCount(activeCount || 0)
    }

    fetchCount()
    const interval = setInterval(fetchCount, 30000)
    return () => clearInterval(interval)
  }, [])

  return count
}

export function useDonationMetrics(months: number = 6) {
  const [data, setData] = useState<{ date: string; amount: number; count: number }[]>([])
  const [loading, setLoading] = useState(true)
  const [totalAmount, setTotalAmount] = useState(0)
  const [totalCount, setTotalCount] = useState(0)

  useEffect(() => {
    const fetchData = async () => {
      try {
        const startDate = new Date()
        startDate.setMonth(startDate.getMonth() - months)
        
        const { data: donations } = await supabase
          .from('donations')
          .select('amount, created_at')
          .gte('created_at', startDate.toISOString())

        const monthlyData: Record<string, { amount: number; count: number }> = {}
        
        // Initialize all months
        for (let i = 0; i < months; i++) {
          const d = new Date()
          d.setMonth(d.getMonth() - i)
          const key = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`
          monthlyData[key] = { amount: 0, count: 0 }
        }

        // Aggregate donations by month
        donations?.forEach((donation) => {
          const date = new Date(donation.created_at)
          const key = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`
          if (monthlyData[key]) {
            monthlyData[key].amount += donation.amount || 0
            monthlyData[key].count++
          }
        })

        const result = Object.entries(monthlyData)
          .map(([date, stats]) => ({ date, ...stats }))
          .sort((a, b) => a.date.localeCompare(b.date))

        const totalAmt = donations?.reduce((acc, d) => acc + (d.amount || 0), 0) || 0
        const totalCnt = donations?.length || 0

        setData(result)
        setTotalAmount(totalAmt)
        setTotalCount(totalCnt)
      } finally {
        setLoading(false)
      }
    }

    fetchData()
  }, [months])

  return { data, loading, totalAmount, totalCount }
}
