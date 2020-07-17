#!/usr/bin/env nextflow
/*
========================================================================================
                         PhilPalmer/data-downloader
========================================================================================
 PhilPalmer/data-downloader Nextflow pipeline to download files using axel
 #### Homepage / Documentation
 https://github.com/PhilPalmer/data-downloader
----------------------------------------------------------------------------------------
*/

Channel
  .fromPath(params.urls)
  .ifEmpty { exit 1, "URLs TXT file not found: ${params.urls}" }
  .splitText()
  .map { it -> it.trim() }
  .set { url }

/*--------------------------------------------------
  Download files
---------------------------------------------------*/

process download_file {
    tag "${url.split("/").last()}"
    publishDir params.outdir
    cpus 1

    input:
    val url from url

    output:
    file('*') into downloaded_files

    script:
    """
    axel $url
    """ 
}
