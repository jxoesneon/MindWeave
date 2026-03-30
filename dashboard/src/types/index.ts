export type NavItem = {
  label: string
  path: string
  icon: string
}

export type AnalyticsMetric = {
  date: string
  value: number
}

export type FrequencyBandStats = {
  band: string
  count: number
  percentage: number
}

export type DashboardStats = {
  totalUsers: number
  activeUsersToday: number
  activeUsersMonth: number
  totalSessions: number
  avgSessionDuration: number
  totalDonations: number
  donationAmount: number
}
