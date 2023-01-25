version 1.0

workflow submit_GISAID {
	input {
		File metadata_csv
		File concatenated_fasta
		File gisaid_upload_token
		String frameshift_setting = "catch_novel"
	}

	call gisaid_cli3 {
		input:
			metadata_csv = metadata_csv,
			concatenated_fasta=concatenated_fasta,
			gisaid_upload_token = gisaid_upload_token,
			frameshift_setting = frameshift_setting

	}
	output {
		File gisaid_upload_log = gisaid_cli3.gisaid_upload_log
		File gisaid_upload_errors = gisaid_cli3.gisaid_upload_errors
	}
}

task gisaid_cli3 {
	input {
		File metadata_csv
		File concatenated_fasta
		File gisaid_upload_token
		String? frameshift_setting
	}

	command <<<
	cli3 upload --token "~{gisaid_upload_token}" --metadata "~{metadata_csv}" --fasta "~{concatenated_fasta}" --frameshift "~{frameshift_setting}"
	>>>

	output {
		File gisaid_upload_log = stdout()
		File gisaid_upload_errors = stderr()
	} 

	runtime {
    	docker: "ewolfsohn/gisaid_cli3:1.0.0"
    	memory:"8 GB"
    	cpu: "4"
    	disks: "local-disk 100 SSD"
    	preemptible:  1
  }
}