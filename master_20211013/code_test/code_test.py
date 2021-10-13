def displayResult(flag):
    if flag == True:
        print (" -	-	-	-	-	-")
        print (" -					-")
        print (" -\033[32m		succssed		\033[0m-")
        print (" -					-")
        print (" -	-	-	-	-	-")
    else:
        print (" -	-	-	-	-	-")
        print (" -					-")
        print (" -\033[31m		failed			\033[0m-")
        print (" -					-")
        print (" -	-	-	-	-	-")




displayResult(1)
displayResult(0)
