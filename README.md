# WolframEngineCI

This repository demonstrates using the Wolfram Engine in GitHub Actions CI to generate symbolic Wigner D matrices for quantum angular momentum calculations.

## Features

- **Automated Wigner D Matrix Generation**: Computes symbolic Wigner D matrices up to ℓ=3, including half-integer values (0, 1/2, 1, 3/2, 2, 5/2, 3)
- **Docker-based Workflow**: Runs Wolfram Engine in a Docker container for reproducible builds
- **Julia-friendly Output**: Exports results in JSON format for easy consumption by Julia or other languages
- **CI Verification**: Automatically validates and uploads generated matrices as artifacts

## Workflow

The GitHub Actions workflow (`.github/workflows/wigner-test.yml`) automatically:

1. Checks out the repository
2. Pulls the Wolfram Engine Docker image
3. Runs the Wigner D matrix generation script
4. Validates the JSON output
5. Uploads the results as artifacts (available for 30 days)

## Usage

The workflow runs automatically on:
- Pushes to the `main` branch
- Pull requests to the `main` branch
- Manual trigger via the Actions tab

### Generated Files

- `wigner_d_matrices.json`: Full symbolic Wigner D matrices with elements for general Euler angles (α, β, γ)
- `wigner_summary.json`: Summary of matrix dimensions and quantum number ranges

### Downloading Results

After the workflow runs, download the artifacts from the Actions tab to access the generated JSON files.

## Script Details

The Wolfram Language script (`scripts/generate_wigner.wl`) computes Wigner D matrices using the ZYZ Euler angle convention. Each matrix element is calculated symbolically for general angles (α, β, γ) and exported in a format that can be easily parsed by Julia or other scientific computing environments.

## Wigner D Matrices

Wigner D matrices are rotation matrices for quantum angular momentum states, with elements:

```
D^ℓ_{m',m}(α,β,γ)
```

where:
- ℓ is the angular momentum quantum number
- m, m' range from -ℓ to ℓ in integer steps
- α, β, γ are Euler angles in the ZYZ convention
