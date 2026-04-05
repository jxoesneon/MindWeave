#!/bin/bash
mkdir -p WorkingMemory/Files

# Find relevant files
files=$(find lib dashboard/src supabase/migrations docs -type f \( -name "*.dart" -o -name "*.ts" -o -name "*.tsx" -o -name "*.sql" -o -name "*.md" \) -not -path "*/\.*" -not -path "*/build/*" -not -path "*/node_modules/*")

total=$(echo "$files" | wc -l)
current=0

echo "Dispatching swarm of agents for $total files..."

echo "$files" | while read -r file; do
    # Skip empty lines
    if [ -z "$file" ]; then continue; fi
    
    # Create safe filename
    outfile="WorkingMemory/Files/$(echo "$file" | tr '/' '_').md"
    
    if [ ! -f "$outfile" ]; then
        # Run gemini agent in background
        (
            content=$(cat "$file")
            gemini -y -o text -p "Analyze the following file. Provide a concise, high-signal technical summary of its purpose, architecture, and dependencies. Output ONLY valid markdown. Do not include ephemeral system messages.
File: $file
Content:
$content" > "$outfile" 2>/dev/null
        ) &
        
        # Limit concurrency to 10 agents to avoid overloading the system or rate limits
        while [ $(jobs -p | wc -l) -ge 10 ]; do
            sleep 1
        done
    fi
done

# Wait for remaining background jobs
wait

echo "Swarm knowledge extraction complete. All files processed."
