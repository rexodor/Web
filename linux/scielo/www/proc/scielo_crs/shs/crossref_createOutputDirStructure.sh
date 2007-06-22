#####
# Gerador de shell com lista de chamanda para o shell crossref_requestXML.sh
# Lista de Parametros
#####

. crossref_config.sh

echo "--- Generating crossref_processSequence.sh"

echo "#temp file" > $conversor_dir/shs/crossref_processSequence.sh 
echo ". crossref_config.sh" > $conversor_dir/shs/crossref_processSequence.sh
$cisis_dir/mx $database_dir/artigo/artigo "proc=@$conversor_dir/prc/Article.prc" "btell=0" "tp=h" "lw=999999" "pft=@$conversor_dir/formats/crossref_generateProcessSequence.pft" "tell=1000" "count=100" now >> $conversor_dir/shs/crossref_processSequence.sh
echo "--- Done!"
echo "--- Running crossref_processSequence.sh to Generating toDoList.txt"
rm toDoList.txt
chmod 777 crossref_processSequence.sh
./crossref_processSequence.sh
rm crossref_processSequence.sh
echo "--- Done!"
