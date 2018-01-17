# Linux Installation Instructions


1. Clone Repo
```sh
git clone https://github.com/respec/HSPsquared/
```
2. Install python requirements
```sh
# Remove included WDMtoolbox as it is not needed. Needed files are installed with pip
rm - r wdmtoolbox

# Install virtualenv if desired, create environment and activate it
apt-get install virtualenv
virtualenv venv
source venv/bin/activate

# Install requirements as included in the requirements.txt file 
pip install --no-cache -r requirements.txt

# Install wdmtoolbox separately as it has conflicts if installed as part of requirements process
pip install --no-cache wdmtoolbox
```

3. Run Jupyter Notebooks
```sh
jupyter-notebook --ip=0.0.0.0  --port=8888 --entry
```
