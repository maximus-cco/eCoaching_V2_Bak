---************************************************---

     --ALL STEPS TO BE COMPLETED IN GIVEN ORDER--


---************************************************---
---************************************************---

STEP 1	- DISABLE ALL SQL AGENT JOBS

		

---************************************************---
---************************************************---

STEP 2  -  PREPARE AND UPDATE DATA

THIS PART CONVERTS ALL IDS IN ALL TABLES TO MAXIMUS VALUES
THIS PART HAS TO BE COMPLETED BEFORE MOVING TO NEXT STEP


--Complete the steps in the below documents in given order
-- additional instructions in the documents

1. Step1_Prep.txt
2. Step2a_Create_SPs.txt
3. Step2b_Updates.txt
4. Step3_Load_Process.txt


---************************************************---
---************************************************---

STEP 3 - IMPLEMENT RUN BOOK CCO_eCoaching_Log_DB_Runbook.docx

This installs all the code changes to support the Maximus Ids going forward.

---************************************************---
---************************************************---


STEP 4 - STAGE EMPLOYEE FILES THAT ARE AVAILABLE
THERE SHOULD BE 3 FILES

1. PS_Employee_Information_mmddccyy.csv (IQS)
2. Employee_Information_WithProgram.csv (ASPECT)
3. HR_Employee_Information.csv (STATIC FILE WITH 37 RECORDS)

ALL OF THESE FILES SHOULD HAVE MAXIMUS IDS

---************************************************---
---************************************************---

STEP 5 - ENABLE JOBS ONE BY ONE
AFTER CHECKING FILES TO MAKE SURE THEY HAVE MAXIMUS IDs

START WITH EMPLOYEE LOAD



---************************************************---
---************************************************---