# WinningSpace
IBM Course Final Project
<details> <summary>Outline</summary>
Project goal
Predict SpaceX launch outcomes with open data and open-source tools.

Folder / file map

dataset_part_*.csv – cleaned data splits

jupyter_labs_spacex_data_collection_api.ipynb – downloads raw data from the SpaceX API

labs_jupyter_spacex_Data_wrangling_v2.ipynb – merges and cleans sources

jupyter_labs_eda_dataviz_v2.ipynb – exploratory data analysis & charts

lab_jupyter_launch_site_location_v2.ipynb – geospatial features

jupyter_labs_eda_sql_coursera_sqllite.ipynb – SQL examples

SpaceX_Machine_Learning_Prediction_Part_5.ipynb – model training & evaluation

run_spacex_pipeline.sh – end-to-end execution script

README.md – this file

Quick start

bash
Copiar
Editar
git clone https://github.com/<user>/WinningSpace.git
cd WinningSpace
bash run_spacex_pipeline.sh
Requirements

Python 3.10+

pip packages listed in requirements.txt

JupyterLab 4+

Data sources

SpaceX REST API

Kaggle SpaceX launches dataset (link)

OpenStreetMap for launch-site coordinates

Method summary

Data ingestion → cleaning → EDA → feature engineering

Model: gradient-boosting classifier (baseline), hyper-parameter search with cross-validation

Metrics: accuracy, F1, confusion matrix

Results

Best model accuracy: …

Key predictors: payload mass, booster version, launch pad, orbit

Reproducibility
Each notebook runs top-to-bottom; the Bash script stitches them together.

Roadmap

Add hyper-parameter tuning with Optuna

Deploy REST endpoint with FastAPI

CI/CD with GitHub Actions

License & citation
MIT License. Cite this repo if you reuse the code or data utilities.

Contact
DrAminCer (at) …

</details>
