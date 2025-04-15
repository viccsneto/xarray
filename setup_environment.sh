#!/bin/bash
# setup_environment.sh: Script to set up xarray development environment on Linux
set -e

# 1. Check for conda/mamba
if ! command -v conda &> /dev/null && ! command -v mamba &> /dev/null; then
    echo "Error: conda or mamba is required but not found. Please install Miniconda or Mambaforge first."
    exit 1
fi

# 2. Use mamba if available, else conda
if command -v mamba &> /dev/null; then
    ENV_CMD=mamba
else
    ENV_CMD=conda
fi

# 3. Create environment from environment.yml
ENV_NAME="xarray-tests"
ENV_FILE="ci/requirements/environment.yml"

$ENV_CMD env create -f $ENV_FILE -n $ENV_NAME || $ENV_CMD env update -f $ENV_FILE -n $ENV_NAME

# 4. Activate environment and install xarray in editable mode
source $(conda info --base)/etc/profile.d/conda.sh
conda activate $ENV_NAME
pip install -e .

# 5. Install optional test dependencies
pip install hypothesis pre-commit

# 6. Install pre-commit hooks
pre-commit install

echo "\nEnvironment setup complete! To activate, run: conda activate $ENV_NAME"
echo "To run tests: pytest"
echo "To run property-based tests: pytest properties/"
echo "To run slow Hypothesis tests: pytest properties/ --run-slow-hypothesis"
