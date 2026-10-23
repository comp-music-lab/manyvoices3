import pandas as pd
import statsmodels.api as sm
from sklearn.preprocessing import StandardScaler

# Load data
df = pd.read_csv("./NuskaEtAl(Czech)/Exploratory analysis/data.csv")

df = df[df['Condition'] == 'S']

# Outcome variable
y = df["Bonding DIFF"]

# Predictor variables
predictors = [
        "f0stab average",
        "I consider myself a musician",
        "I have been complimented for my talents as a musical performer",
        "I know the song we sung",
        "I like the song we sang",
        "I sing regularly",
        "How many years of formal musical training have you had in singing?",
        "How many years of formal musical training have you had in musical instruments?"
    ]


scaler = StandardScaler()

X_scaled = pd.DataFrame(
    scaler.fit_transform(df[predictors]),
    columns=predictors
)

y_scaled = scaler.fit_transform(
    df[["Bonding DIFF"]]
).ravel()

X_scaled = sm.add_constant(X_scaled)

model = sm.OLS(y_scaled, X_scaled).fit()
print(model.summary())

