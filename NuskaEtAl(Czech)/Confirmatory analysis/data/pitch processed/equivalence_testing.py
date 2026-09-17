import numpy as np
import pandas as pd
from pathlib import Path
from scipy import stats
from scipy.optimize import brentq


# ============================================================
# SETTINGS
# ============================================================

DATA_DIR = Path(
    "NuskaEtAl(Czech)/Confirmatory analysis/data/pitch processed"
)

ALPHA = 0.05
N_HYPOTHESES = 3
ALPHA_TEST = ALPHA / N_HYPOTHESES

LOWER_EQ = 0.39
UPPER_EQ = 0.61

EXACTCI_RANDOM_SEED = 42


# ============================================================
# RELATIVE EFFECT
# ============================================================

def relative_effect(x, y):

    x = np.asarray(x, dtype=float).ravel()
    y = np.asarray(y, dtype=float).ravel()

    x = x[np.isfinite(x)]
    y = y[np.isfinite(y)]

    nx = len(x)
    ny = len(y)

    if nx < 2 or ny < 2:
        raise ValueError(
            "Both groups need at least 2 observations."
        )

    pooled = np.concatenate([x, y])

    ranks = stats.rankdata(
        pooled,
        method="average"
    )

    rx = ranks[:nx]
    ry = ranks[nx:]

    rx_within = stats.rankdata(
        x,
        method="average"
    )

    ry_within = stats.rankdata(
        y,
        method="average"
    )

    rbar_x = np.mean(rx)
    rbar_y = np.mean(ry)

    A = (
        1
        - (rbar_y - (ny + 1) / 2) / nx
    )

    if np.isclose(A, 1.0):

        A = 1 - 1 / (2 * nx * ny)

        Sx2 = 1 / (4 * nx)
        Sy2 = 1 / (4 * ny)

    elif np.isclose(A, 0.0):

        A = 1 / (2 * nx * ny)

        Sx2 = 1 / (4 * nx)
        Sy2 = 1 / (4 * ny)

    else:

        Sx2 = (
            np.sum(
                (
                    rx
                    - rx_within
                    - rbar_x
                    + (nx + 1) / 2
                ) ** 2
            )
            / (nx - 1)
        )

        Sy2 = (
            np.sum(
                (
                    ry
                    - ry_within
                    - rbar_y
                    + (ny + 1) / 2
                ) ** 2
            )
            / (ny - 1)
        )

    tau = (
        np.sqrt(nx * Sx2 + ny * Sy2)
        / (nx * ny)
    )

    return A, tau


# ============================================================
# EXACTCI MU-HAT
# ============================================================

def _exactci_sign_matrix(k, random_seed=None, L=16):

    if k <= L:

        n_signs = 2 ** k

        values = np.arange(
            n_signs,
            dtype=np.uint64
        )

        shifts = np.arange(
            k - 1,
            -1,
            -1,
            dtype=np.uint64
        )

        V = (
            (values[:, None] >> shifts) & 1
        ).T.astype(float)

    else:

        rng = np.random.default_rng(
            random_seed
        )

        V = rng.integers(
            0,
            2,
            size=(k, 2 ** L),
            dtype=np.int8
        ).astype(float)

    V[V == 0] = -1.0

    return V


def _exactci_stat(mu, Y, sgm, V):

    tau_sq_mu = max(
        0.0,
        np.mean(
            (Y - mu) ** 2
            - sgm ** 2
        )
    )

    sgm_musq = sgm ** 2 + tau_sq_mu

    w = (Y - mu) / sgm_musq

    T_mu = np.sum(w)

    T_null = np.abs(w) @ V

    return T_mu, T_null


def exactci_mu_hat(
    Y,
    sgm,
    random_seed=None
):

    Y = np.asarray(
        Y,
        dtype=float
    ).ravel()

    sgm = np.asarray(
        sgm,
        dtype=float
    ).ravel()

    if Y.size != sgm.size:
        raise ValueError(
            "Y and sgm must have the same length."
        )

    if Y.size < 2:
        raise ValueError(
            "Need at least two effect estimates."
        )

    V = _exactci_sign_matrix(
        len(Y),
        random_seed=random_seed
    )

    mu_min = float(np.min(Y))
    mu_max = float(np.max(Y))

    if mu_min == mu_max:
        return mu_min

    def equation(mu):

        T_mu, T_null = _exactci_stat(
            mu,
            Y,
            sgm,
            V
        )

        return (
            T_mu
            - np.quantile(T_null, 0.5)
        )

    if equation(mu_min) == 0:
        return mu_min

    if equation(mu_max) == 0:
        return mu_max

    if (
        equation(mu_min)
        * equation(mu_max)
        > 0
    ):
        raise RuntimeError(
            "exactCI mu_hat root is not bracketed."
        )

    return brentq(
        equation,
        mu_min,
        mu_max
    )


# ============================================================
# ROMANO CRITICAL VALUE
# ============================================================

def romano_critical(
    alpha,
    delta,
    sigma
):

    def equation(C):

        return (
            stats.norm.cdf(
                (C - delta) / sigma
            )
            -
            stats.norm.cdf(
                (-C - delta) / sigma
            )
            -
            alpha
        )

    upper = max(
        delta + 10 * sigma,
        10 * sigma,
        1.0
    )

    while equation(upper) < 0:
        upper *= 2

    return brentq(
        equation,
        0,
        upper
    )


# ============================================================
# LOAD DATA
# ============================================================

csv_files = sorted(
    DATA_DIR.glob("*.csv")
)

if not csv_files:
    raise ValueError(
        f"No CSV files found in {DATA_DIR}"
    )


all_data = []

for file in csv_files:

    tmp = pd.read_csv(file)

    required = [
        "speaker",
        "condition",
        "f0stab"
    ]

    if not all(
        c in tmp.columns
        for c in required
    ):
        continue

    tmp = tmp[
        tmp["condition"].isin(
            ["sing", "conv"]
        )
    ].dropna(
        subset=required
    )

    all_data.append(
        tmp[required]
    )


if not all_data:
    raise ValueError(
        "No usable data found."
    )


df = pd.concat(
    all_data,
    ignore_index=True
)


# ============================================================
# SPEAKER-LEVEL EFFECTS
# ============================================================

effects = []

for speaker, speaker_df in df.groupby(
    "speaker"
):

    x = speaker_df.loc[
        speaker_df["condition"] == "sing",
        "f0stab"
    ].to_numpy()

    y = speaker_df.loc[
        speaker_df["condition"] == "conv",
        "f0stab"
    ].to_numpy()

    if len(x) < 2 or len(y) < 2:
        continue

    A, tau = relative_effect(x, y)

    effects.append(
        {
            "speaker": speaker,
            "A": A,
            "variance": tau ** 2
        }
    )


effects = pd.DataFrame(effects)

if len(effects) < 2:
    raise ValueError(
        "Need at least two speakers."
    )


# ============================================================
# DER SIMONIAN-LAIRD BETWEEN-STUDY VARIANCE
# ============================================================

yi = effects["A"].to_numpy()
vi = effects["variance"].to_numpy()

k = len(yi)

wi = 1 / vi

fixed_mean = (
    np.sum(wi * yi)
    / np.sum(wi)
)

Q = np.sum(
    wi * (yi - fixed_mean) ** 2
)

C_DL = (
    np.sum(wi)
    - np.sum(wi ** 2)
    / np.sum(wi)
)

tau_between_sq = max(
    0,
    (Q - (k - 1)) / C_DL
)


# ============================================================
# EXACTCI MEAN USED BY ROMANO
# ============================================================

mu_hat = exactci_mu_hat(
    yi,
    np.sqrt(vi),
    random_seed=EXACTCI_RANDOM_SEED
)


# ============================================================
# OVERALL VARIANCE
# ============================================================

overall_variance = np.mean(
    vi + tau_between_sq
)

romano_se = (
    np.sqrt(overall_variance)
    / np.sqrt(k)
)


# ============================================================
# ROMANO EQUIVALENCE TEST
# ============================================================

center = (
    LOWER_EQ + UPPER_EQ
) / 2

delta = (
    UPPER_EQ - LOWER_EQ
) / 2

theta_hat = (
    mu_hat - center
)

C_romano = romano_critical(
    alpha=ALPHA_TEST,
    delta=delta,
    sigma=romano_se
)

romano_stat = abs(theta_hat)

equivalence = (
    romano_stat < C_romano
)


# ============================================================
# ROMANO P-VALUE
# ============================================================

p_romano = (
    stats.norm.cdf(
        (romano_stat - delta)
        / romano_se
    )
    -
    stats.norm.cdf(
        (-romano_stat - delta)
        / romano_se
    )
)


# ============================================================
# OUTPUT
# ============================================================

print("----------------------------------------")
print("ROMANO EQUIVALENCE TEST")
print("----------------------------------------")

print(
    f"alpha = {ALPHA_TEST:.6f}"
)

print(
    f"|A - 0.5| = "
    f"{romano_stat:.6f}"
)

print(
    f"Romano critical value = "
    f"{C_romano:.6f}"
)

print(
    f"Romano p-value = "
    f"{p_romano:.20f}"
)

if equivalence:

    print(
        "\nEQUIVALENCE ESTABLISHED"
    )

    print(
        "The Romano shrinking-parameter-space "
        "test rejects the null of non-equivalence."
    )

else:

    print(
        "\nEQUIVALENCE NOT ESTABLISHED"
    )

    print(
        "The Romano shrinking-parameter-space "
        "test does not reject the null of non-equivalence."
    )