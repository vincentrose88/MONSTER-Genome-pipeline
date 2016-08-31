#!/usr/bin/python
import os,sys,getopt,random,math#,fileinput

#def main(argv):
#    '''Main function that takes in all commandline arguments and parses them to a correct bsub, with output and error files named aptly'''
argv = sys.argv[1:]
room = 'green'
mem = '1000'
name = 'tmp'
wait = 'NULL'
printflag = False
suffix = int(math.floor(random.random()*100000))
suffixflag = True
queue = 'normal'

#Error catcher and definder of option argument
try:
    opts, args = getopt.getopt(argv,"hspr:m:n:w:q:",["room=","mem=","name=","wait=","queue="])
except getopt.GetoptError:
    print 'submit_jobarray.py command-to-be-submittet-from-stdin -[psh] -[rmnwq] <values>'
    sys.exit(2)
#Actually 
for opt, arg in opts:
    if opt == '-h':
        print 'submit_jobarray.py command-to-be-submittet -[psh] -[rmnwq] <values>'
        print '<values>'
        print '-r/--room: color of room: green/red (default=green)'
        print '-m/--mem: memory required. Default 1g (accepts g as a short for giga, ie. 1g=1000)'
        print '-n/--name: name of job. Default tmp'
        print '-w/--wait: wait on another job, ie dependicies. Default is NULL (add the ID or jobname you want to be dependent on'
        print '-q/--queue: Which queue do you want to submit to? Default: normal'
        print 'Flags:'
        print '-p: Do you want to bsub command to be printet? Just add the -f flag. Default False, ie no flag)'
        print '-s: Do you want to remove the random number as a suffix to your filenames to increase the probablity of overwriting, appending and all that jazz? Add the flag'
        print '-h prints this help screen and quits'
        sys.exit()
    elif opt in ("-r", "--room"):
        room = arg
    elif opt in ("-m", "--mem"):
        mem = arg
    elif opt in ("-n", "--name"):
        name = arg
    elif opt in ("-w", "--wait"):
        wait = arg
    elif opt in ("-p"):
        printflag = True
    elif opt in ("-s"):
        suffixflag = False
    elif opt in ("-q", "--queue"):
        queue = arg


jobname = name #maintaining that the jobname is always without the random number

if(suffixflag):
    #adding the random number suffix to the name
    name = name + str(suffix)

#if __name__ == "__main__":
#main(sys.argv[1:])

#print(len(sys.stdin))


   #Writes the command file, adding a line for each command in the case of an array
script = open(name+'.command','a')
maxi=0
for command in sys.stdin:
    script.write(command)
    maxi+=1
maxi = str(maxi)

script.close()
os.system('chmod +x ' + name + '.command')
    
   #Writes the exe file with the simple loop that goes though the command file and sends the command to the grid enginge
exe = open(name+'.exe','w')
exe.write('$(head -n $1 '+name+'.command'+' | tail -n 1)')
exe.close()
os.system('chmod +x ' + name + '.exe')

   #Reformats the mem to a number (if it was sat to 1g fx)
mem=str.replace(mem,'g','000')

  #Resources is just to make it easier to read
resources = '-R "select[mem>'+mem+' && '+room+'] rusage[mem='+mem+']" -M '+mem
   #The bsubcommand with flags
bsubcommand = 'bsub ' + resources + \
    ' -J "' + jobname + '[1-'+maxi+']"' + \
    ' -o ' + name + '.%I.o ' + \
    ' -e ' + name + '.%I.e ' + \
    ' -q ' + queue
   #Is there any dependices?
if(wait!='NULL'):
    bsubcommand = bsubcommand + ' -w "done('+wait+'[*])"'
        
   #Finally adds the exe command to the bsubcommand and runs if, execpt if the -p/--print flag is sat    
bsubcommand = bsubcommand + " './" + name + ".exe $LSB_JOBINDEX'"
        
if(printflag):
    print bsubcommand
else:
    os.system(bsubcommand)
    print('\n with the following command:')
    print bsubcommand
