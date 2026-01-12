## 🚀 Employee Attrition Prediction using Random Forest

This project develops a robust Machine Learning solution to predict employee turnover.

### 🎯 Business Problem

High employee attrition rates lead to substantial costs (recruitment, training, lost productivity). This model uncovers the root causes of turnover and provides an actionable prediction score.

### 🛠️ Key Technologies

* **Models:** Random Forest Classifier, Decision Tree
* **Libraries:** `scikit-learn`, `pandas`, `seaborn`, `dtreeviz`
* **Tuning:** `RandomizedSearchCV` (using F1 Score)
* **Environment:** Conda (`environment.yml` provided for reproducibility)

### 📊 Methodology & Performance

1.  **Exploratory Data Analysis (EDA):** Identified strong correlations between key features and `Attrition` (e.g., **Satisfaction Level**, **Time Spent Company**).
2.  **Optimization:** The Random Forest model was fine-tuned using `RandomizedSearchCV` and achieved excellent generalization.
3.  **Evaluation:** The final model was evaluated using **F1 Score** that was chosen for robust performance on imbalanced data:
    * **F1 Score:** ~0.98
    * **Accuracy:** ~0.99

### 🔑 Key Findings (Feature Importance)

The model's **Feature Importance Analysis** revealed the most critical factors influencing attrition:

1.  **Satisfaction Level**
2.  **Time Spend Company**
3.  **Number of Projects**

### ✅ Conclusion & Impact

The Random Forest Classifier is highly effective at identifying employees at risk. The key insight is that employee satisfaction is the most urgent factor. This model provides an essential tool for HR to prioritize targeted efforts and minimize financial loss due to turnover.

---

### ⚙️ Getting Started

To recreate the environment and run the project:

1.  Clone the repository.
2.  Create the Conda environment using the provided file:
    ```bash
    conda env create -f environment.yml
    conda activate decision_tree_venv
    ```
3.  Open and run the main notebook: `Decision_Tree&Random_Forest_Classifier.ipynb`.