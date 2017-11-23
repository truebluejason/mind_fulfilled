class Log

	def initialize duration, distractions, distraction_counts, q1, q2, q3
		@date = Time.now
		@duration = duration
		# maps distractions to distraction counts
		@contents = {}
		for i in 0...distraction_counts.length do
			@contents[distractions[i]] = distraction_counts[i]
		end
		@q1 = q1
		@q2 = q2
		@q3 = q3
	end

	# Unshift this log_hash to the top of the session_info array
	def to_hash
		log_hash = {
			'date'		=> @date,
			'duration' 	=> @duration,
			'contents' 	=> @contents,
			'notes' => {
				'q1' => @q1,
				'q2' => @q2,
				'q3' => @q3
			}
		}
		return log_hash
	end
end