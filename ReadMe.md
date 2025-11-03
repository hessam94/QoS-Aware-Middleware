# **Research Summary: QoE Estimation for Video Streaming**

In this research, we aimed to improve **Quality of Experience (QoE)** estimation for video streaming applications using **Quality of Service (QoS)** parameters — effectively creating a **mapping from QoS to QoE**.  
The study was conducted in several key steps:

---

## **1. Subjective Test**
- Conducted a **real-world subjective experiment** with **20 participants**.  
- Each participant rated **30 distorted video samples**, each with a different **distortion rate**.  
- These ratings provided the **ground-truth QoE scores** used for model training.

---

## **2. Hybrid Machine Learning Training**
- **Input features:**
  - Network **loss rate**
  - **Mean loss burst size**
- **Target values:**
  - Subjective **QoE scores** obtained from the user study
- Trained a **neural network model** to estimate QoE based on video distortion levels.  
- Enabled **real-time video resolution adaptation** according to current network conditions.

---

## **3. Algorithm Enhancement**
- Improved the **Random Neural Network (RNN)** algorithm.  
- Achieved **higher estimation precision** and more **accurate QoE prediction** performance.

---

