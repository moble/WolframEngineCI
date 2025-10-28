#!/usr/bin/env wolframscript
(* 
 * Wolfram Language Script to Generate Wigner D Matrices
 * 
 * This script generates symbolic Wigner D matrices up to ℓ=3, including
 * half-integer values (ℓ = 0, 1/2, 1, 3/2, 2, 5/2, 3).
 * 
 * Wigner D matrices are rotation matrices for quantum angular momentum states,
 * parameterized by Euler angles (α, β, γ) in the ZYZ convention.
 * 
 * The matrix elements are computed using the WignerD function:
 * D^ℓ_{m',m}(α,β,γ) where m', m range from -ℓ to ℓ in integer steps.
 * 
 * Output: JSON file containing all matrix elements in a Julia-friendly format
 *)

Print["Starting Wigner D matrix generation..."];

(* Define the range of ℓ values including half-integers *)
lValues = {0, 1/2, 1, 3/2, 2, 5/2, 3};

(* Symbolic Euler angles *)
alpha = α;
beta = β;
gamma = γ;

(*
 * Function to generate a Wigner D matrix for a given ℓ value
 * 
 * Parameters:
 *   l - angular momentum quantum number (integer or half-integer)
 *   a, b, g - Euler angles (α, β, γ)
 * 
 * Returns:
 *   Association with matrix elements and metadata
 *)
GenerateWignerDMatrix[l_, a_, b_, g_] := Module[
  {mValues, matrix, elements},
  
  (* Generate m values from -ℓ to ℓ *)
  mValues = Range[-l, l, 1];
  
  (* Compute matrix elements D^ℓ_{m',m}(α,β,γ) *)
  (* Note: WignerD in Mathematica uses convention WignerD[{l, m1, m2}, α, β, γ] *)
  matrix = Table[
    WignerD[{l, mp, m}, a, b, g],
    {mp, mValues},
    {m, mValues}
  ];
  
  (* Simplify the matrix elements *)
  matrix = FullSimplify[matrix];
  
  (* Convert to a list of matrix elements with indices *)
  elements = Table[
    <|
      "mp" -> mp,
      "m" -> m,
      "element" -> ToString[matrix[[Position[mValues, mp][[1,1]], Position[mValues, m][[1,1]]]], InputForm]
    |>,
    {mp, mValues},
    {m, mValues}
  ];
  
  (* Return the matrix data as an association *)
  <|
    "l" -> l,
    "dimension" -> Length[mValues],
    "m_values" -> mValues,
    "matrix" -> matrix,
    "elements" -> Flatten[elements]
  |>
];

(* Generate all Wigner D matrices *)
Print["Computing Wigner D matrices for ℓ = ", lValues];
wignerData = Table[
  Print["  Computing ℓ = ", l];
  GenerateWignerDMatrix[l, alpha, beta, gamma],
  {l, lValues}
];

(* 
 * Prepare data for JSON export
 * Convert symbolic expressions to strings for Julia compatibility
 *)
Print["Preparing data for JSON export..."];

jsonData = <|
  "description" -> "Wigner D matrices for angular momentum quantum numbers up to ℓ=3",
  "euler_angles" -> <|
    "alpha" -> "α",
    "beta" -> "β",
    "gamma" -> "γ",
    "convention" -> "ZYZ"
  |>,
  "matrices" -> Table[
    <|
      "l" -> data["l"],
      "dimension" -> data["dimension"],
      "m_values" -> data["m_values"],
      "elements" -> Table[
        <|
          "mp" -> elem["mp"],
          "m" -> elem["m"],
          "value" -> elem["element"]
        |>,
        {elem, data["elements"]}
      ]
    |>,
    {data, wignerData}
  ]
|>;

(* Export to JSON file *)
outputFile = "wigner_d_matrices.json";
Print["Exporting to ", outputFile];
Export[outputFile, jsonData, "JSON", "Compact" -> False];

Print["Successfully generated Wigner D matrices!"];
Print["Output saved to: ", outputFile];

(* Also create a summary file with matrix dimensions *)
summaryData = <|
  "summary" -> Table[
    <|
      "l" -> data["l"],
      "dimension" -> data["dimension"],
      "m_range" -> {-data["l"], data["l"]}
    |>,
    {data, wignerData}
  ],
  "total_matrices" -> Length[lValues],
  "l_values" -> lValues
|>;

Export["wigner_summary.json", summaryData, "JSON"];
Print["Summary saved to: wigner_summary.json"];

(* Exit successfully *)
Quit[0];
