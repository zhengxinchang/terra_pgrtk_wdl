version 1.0

workflow runPGRTKALL {
    input {
        Array[File] input_files
        File reference_file
        Int threads = 8
        String mem = "60 GB"
        String disk = "512 GB"
        String output_filename_prefix
        String docker_image = "quay.io/zhengxc93/pgrtk-cloud1:latest"
    }

    call RunAGCCreateAndPGRTKmdb {
        input:
            input_files = input_files,
            reference_file = reference_file,
            threads = threads,
            output_filename = output_filename_prefix,
            docker_image = docker_image,
            mem = mem,
            disk = disk
    }

    output {
        File agc_output = RunAGCCreateAndPGRTKmdb.agc_output
        File pgrtk_mdb = RunAGCCreateAndPGRTKmdb.pgrtk_mdb
        File pgrtk_midx = RunAGCCreateAndPGRTKmdb.pgrtk_midx
    }
}

task RunAGCCreateAndPGRTKmdb {
    input {
        Array[File] input_files
        File reference_file
        Int threads
        String output_filename
        String docker_image
        String mem
        String disk
    }

    # Create a file containing the paths of all input files
    command <<<
        # Create a text file with the paths of all input files
        for file in ~{sep=' ' input_files}; do
            echo $file >> input_paths.txt
        done

        # Run AGC create command
        /software/bins/agc create -i input_paths.txt -t ~{threads} ~{reference_file} > ~{output_filename}.agc

        echo ~{output_filename}.agc > ~{output_filename}.mdb.input.txt

        /software/bins/pgr-mdb ~{output_filename}.mdb.input.txt  ~{output_filename}

    >>>

    output {
        File agc_output = "~{output_filename}.agc"
        File pgrtk_mdb = "~{output_filename}.mdb"
        File pgrtk_midx = "~{output_filename}.midx"
    }

    runtime {
        docker: docker_image
        cpu: threads
        memory: mem
        disk: disk
    }
}

