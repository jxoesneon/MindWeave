export function PageLoader() {
  return (
    <div className="min-h-[60vh] flex items-center justify-center">
      <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
    </div>
  )
}

export function SkeletonCard({ rows = 3 }: { rows?: number }) {
  return (
    <div className="bg-surface rounded-lg p-6 border border-gray-800 animate-pulse">
      <div className="h-4 bg-gray-700 rounded w-1/3 mb-4"></div>
      {Array.from({ length: rows }).map((_, i) => (
        <div key={i} className="h-3 bg-gray-700 rounded w-full mb-2"></div>
      ))}
    </div>
  )
}

export function SkeletonTable({ rows = 5 }: { rows?: number }) {
  return (
    <div className="bg-surface rounded-lg border border-gray-800 overflow-hidden animate-pulse">
      <div className="bg-background border-b border-gray-800 p-4">
        <div className="h-4 bg-gray-700 rounded w-1/4"></div>
      </div>
      {Array.from({ length: rows }).map((_, i) => (
        <div key={i} className="p-4 border-b border-gray-800 flex space-x-4">
          <div className="h-4 bg-gray-700 rounded w-1/6"></div>
          <div className="h-4 bg-gray-700 rounded w-1/4"></div>
          <div className="h-4 bg-gray-700 rounded w-1/3"></div>
          <div className="h-4 bg-gray-700 rounded w-1/6 ml-auto"></div>
        </div>
      ))}
    </div>
  )
}
