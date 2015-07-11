Brian Doolittle, Pratap Luitel
Final Project, COSC 174, Dartmouth College
-------------------------------------------------------------------------
INSTRUCTIONS 
The files related to the final model(matrix factorization) are named MF*.m and can be found in the folder finalModel. 

Initialize(create and save the needed data matrices)

	MF_init: creates a 10%holdout randomly for testing and separates the rest for training
	MF_init_causal: divides train and test set based on time. 

Run 
	MFmain(lambda1,lambda2,gamma,niter) 
		recommended input = (0.001,0.001,0.001,10) 
	MFmain_ColdStart(Case,lambda1,lambda2,gamma,niter,N)  
		Does not require separate initialization.So the first step can be bypassed if this script is run.
		input arguments:
		Case - one of 'newArtist','newUser','newTrack'
		lambda1,lambda2,gamma = 0.001 each
		niter = 10, N = 10
		
Note: because cross validation takes longer time, we have commented out the looping variable values in line 92. To fully evaluate the error for all cross validation folds, variable j should be ranged from 0:N-1 and line 148 needs to be uncommented as well.  
--------------------------------------------------------------------------
files from earlier models can be found in olderModels folder. 


