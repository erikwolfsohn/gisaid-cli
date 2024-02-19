version 1.0

workflow submit_GISAID {
	input {
		File metadata_csv
		File concatenated_fasta
		File covCLI_uploader
		String frameshift_setting = "catch_novel"
		String GISAID_username
		String GISAID_password
		String GISAID_client_id
		String date_format = "YYYYMMDD"
	}

	call gisaid_cli_submission {
		input:
			metadata_csv = metadata_csv,
			concatenated_fasta=concatenated_fasta,
			covCLI_uploader=covCLI_uploader,
			GISAID_username=GISAID_username,
			GISAID_password=GISAID_password,
			GISAID_client_id=GISAID_client_id,
			date_format=date_format,
			frameshift_setting = frameshift_setting

	}

	output {
		File gisaid_upload_log = gisaid_cli_submission.gisaid_upload_log
	}
}

task gisaid_cli_submission {
	input {
		# Output from Theiagen Mercury workflows
		File metadata_csv
		File concatenated_fasta

		# Download the Linux release from gisaid.org and place the "covCLI" file in your Terra workspace
		File covCLI_uploader

		String frameshift_setting = "catch_novel"
		# "catch_all" = catch all frameshifts or spike truncations and require email confirmation
    	# "catch_novel" = catch novel frameshifts or spike truncations and require email confirmation
    	# "catch_none" = catch none of the frameshifts or spike truncations and release immediately

		String GISAID_username
		String GISAID_password
		String GISAID_client_id
		# Submitter's client-ID. Follow the steps in the README to request a client-ID.

		String date_format = "YYYYMMDD"
		# Specify the date format, with 'Y' for 'year', 'M' for 'month', 'D' for 'day'. Dates will parse correctly with the following delimiters: '/', '.', '–' or '-'. (default: YYYYMMDD)
	}

	command <<<
	chmod +x ~{covCLI_uploader}
	cp ~{covCLI_uploader} /bin
	
	covCLI upload  --username "~{GISAID_username}" \
	--password "~{GISAID_password}" \
	--clientid "~{GISAID_client_id}" \
	--log logfile.txt \
	--metadata "~{metadata_csv}" \
	--fasta "~{concatenated_fasta}" \
	--dateformat "~{date_format}" \
	--frameshifts "~{frameshift_setting}"

	>>>

	output {
		File gisaid_upload_log = "logfile.txt"
	} 

	runtime {
    	docker: "library/ubuntu:jammy"
    	memory:"8 GB"
    	cpu: "4"
    	disks: "local-disk 100 SSD"
    	preemptible:  1
  }
}