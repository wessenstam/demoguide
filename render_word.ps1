# Script to convert all MD files into seperate docx files
# -----------------------------------------------------------------
# v0.1 - Initial version - Willem Essenstam - Delinea - 25-10-2022
#
# -----------------------------------------------------------------

# Function to cd to the source and build the docx file. This due to relative paths for the images
function build_page($filefull,$counter){
        
    try
    {
        $filename=$filefull.Substring($filefull.lastIndexOf('/')+1)
        $directory=$filefull.Substring(0, $filefull.lastIndexOf('/'))
    }
    catch
    {
        $filename=$filefull
        $directory="./"
    }
    # Run the command to build the docx version of the MD file
    cd $directory ; if($?){pandoc -s -t docx -o C:\Users\WEssenstam.DELINEA\github\demoguide\output$counter.docx $filename}
    cd C:\Users\WEssenstam.DELINEA\github\demoguide

}

# Function for the creation of the list of MD files that need to be converted into word
function get_files{

    $files_raw=get-content .\mkdocs.yml | select-string ".md" | select-string ":"
    $files_split_arr=$files_raw.Line.Split(":")
    $filenames_arr=@()
    foreach ($data in $files_split_arr){
        if ($data | select-string ".md"){
            $filenames_arr+="docs/"+$data.trim()
        }
    }
    return $filenames_arr

}
# Get the MD files including their directory location from the mkdocs.yml so we have the correct order for the docx files
$files=get_files

# Set the counter to 0 so we can use it for the docx files
$counter=1

# Build the docx files using pandoc
foreach ($filefull in $files){
    build_page $filefull $counter
    $counter+=1
}
