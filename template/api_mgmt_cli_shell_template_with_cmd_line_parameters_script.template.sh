#!/bin/bash
#
# SCRIPT Base Template for API CLI Operations with command line parameters script utilization
#
ScriptVersion=00.27.05
ScriptDate=2018-03-05

#

export APIScriptVersion=v00x27x05
ScriptName=api_mgmt_cli_shell_template_with_cmd_line_parameters_script.template

# =================================================================================================
# =================================================================================================
# START script
# =================================================================================================
# =================================================================================================


# MODIFIED 2018-03-05 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# =================================================================================================
# -------------------------------------------------------------------------------------------------
# START Initial Script Setup
# -------------------------------------------------------------------------------------------------


echo
echo 'Script:  '$ScriptName'  Script Version: '$APIScriptVersion

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-05

# MODIFIED 2018-03-05 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# -------------------------------------------------------------------------------------------------
# Handle important basics
# -------------------------------------------------------------------------------------------------

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-05

# MODIFIED 2018-03-05 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#points to where jq is installed
#Apparently MDM, MDS, and Domains don't agree on who sets CPDIR, so better to check!
#export JQ=${CPDIR}/jq/jq
if [ -r ${CPDIR}/jq/jq ] 
then
    export JQ=${CPDIR}/jq/jq
elif [ -r /opt/CPshrd-R80/jq/jq ]
then
    export JQ=/opt/CPshrd-R80/jq/jq
else
    echo "Missing jq, not found in ${CPDIR}/jq/jq or /opt/CPshrd-R80/jq/jq"
    exit 1
fi

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-05

# MODIFIED 2018-03-05 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

export currentapisslport=$(clish -c "show web ssl-port" | cut -d " " -f 2)

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-05

# MODIFIED 2018-03-05 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

export minapiversionrequired=1.0

getapiversion=$(mgmt_cli show api-versions --format json -r true --port $currentapisslport | $JQ '.["current-version"]' -r)
export checkapiversion=$getapiversion
if [ $checkapiversion = null ] ; then
    # show api-versions does not exist in version 1.0, so it fails and returns null
    currentapiversion=1.0
else
    currentapiversion=$checkapiversion
fi

echo 'API version = '$currentapiversion

if [ $(expr $minapiversionrequired '<=' $currentapiversion) ] ; then
    # API is sufficient version
    echo
else
    # API is not of a sufficient version to operate
    echo
    echo 'Current API Version ('$currentapiversion') does not meet minimum API version requirement ('$minapiversionrequired')'
    echo
    echo '! termination execution !'
    echo
    exit 250
fi

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-05

# MODIFIED 2018-03-05 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

if [ -z $APISCRIPTVERBOSE ] ; then
    # Verbose mode not set from shell level
    echo "!! Verbose mode not set from shell level"
    export APISCRIPTVERBOSE=false
    echo
elif [ x"`echo "$APISCRIPTVERBOSE" | tr '[:upper:]' '[:lower:]'`" = x"false" ] ; then
    # Verbose mode set OFF from shell level
    echo "!! Verbose mode set OFF from shell level"
    export APISCRIPTVERBOSE=false
    echo
elif [ x"`echo "$APISCRIPTVERBOSE" | tr '[:upper:]' '[:lower:]'`" = x"true" ] ; then
    # Verbose mode set ON from shell level
    echo "!! Verbose mode set ON from shell level"
    export APISCRIPTVERBOSE=true
    echo
    echo 'Script :  '$0
    echo 'Verbose mode enabled'
    echo
else
    # Verbose mode set to wrong value from shell level
    echo "!! Verbose mode set to wrong value from shell level >"$APISCRIPTVERBOSE"<"
    echo "!! Settting Verbose mode OFF, pending command line parameter checking!"
    export APISCRIPTVERBOSE=false
    echo
fi

export APISCRIPTVERBOSECHECK=true

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-05

# MODIFIED 2018-03-05 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# -------------------------------------------------------------------------------------------------
# END Initial Script Setup
# -------------------------------------------------------------------------------------------------
# =================================================================================================

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2017-08-28


# -------------------------------------------------------------------------------------------------
# Root script declarations
# -------------------------------------------------------------------------------------------------

# ADDED 2017-07-21 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

export script_use_publish="true"

export script_use_export="true"
export script_use_import="true"
export script_use_delete="true"

export script_dump_standard="false"
export script_dump_full="false"
export script_dump_csv="false"

export script_use_csvfile="true"

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/- ADDED 2017-07-21
# ADDED 2017-08-03 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# Wait time in seconds
export WAITTIME=15

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/- ADDED 2017-08-03


# MODIFIED 2018-03-04 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# =================================================================================================
# =================================================================================================
# START:  Command Line Parameter Handling and Help
# =================================================================================================


# Code template for parsing command line parameters using only portable shell
# code, while handling both long and short params, handling '-f file' and
# '-f=file' style param data and also capturing non-parameters to be inserted
# back into the shell positional parameters.
#
# Standard Command Line Parameters
#
# -? | --help
# -v | --verbose
# -P <web-ssl-port> | --port <web-ssl-port> | -P=<web-ssl-port> | --port=<web-ssl-port>
# -r | --root
# -u <admin_name> | --user <admin_name> | -u=<admin_name> | --user=<admin_name>
# -p <password> | --password <password> | -p=<password> | --password=<password>
# -m <server_IP> | --management <server_IP> | -m=<server_IP> | --management=<server_IP>
# -d <domain> | --domain <domain> | -d=<domain> | --domain=<domain>
# -s <session_file_filepath> | --session-file <session_file_filepath> | -s=<session_file_filepath> | --session-file=<session_file_filepath>
# -l <log_path> | --log-path <log_path> | -l=<log_path> | --log-path=<log_path>'
#
# -x <export_path> | --export <export_path> | -x=<export_path> | --export=<export_path> 
# -i <import_path> | --import-path <import_path> | -i=<import_path> | --import-path=<import_path>'
# -k <delete_path> | --delete-path <delete_path> | -k=<delete_path> | --delete-path=<delete_path>'
#
# -c <csv_path> | --csv <csv_path> | -c=<csv_path> | --csv=<csv_path>'
#
# --NSO | --no-system-objects
# --SO | --system-objects
#

export SHOWHELP=false
export CLIparm_websslport=443
export CLIparm_rootuser=false
export CLIparm_user=
export CLIparm_password=
export CLIparm_mgmt=
export CLIparm_domain=
export CLIparm_sessionidfile=
export CLIparm_logpath=

export CLIparm_exportpath=
export CLIparm_importpath=
export CLIparm_deletepath=

export CLIparm_csvpath=

export CLIparm_NoSystemObjects=true

export REMAINS=

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-04

# MODIFIED 2018-03-04 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# -------------------------------------------------------------------------------------------------
# dumpcliparmparseresults
# -------------------------------------------------------------------------------------------------

dumpcliparmparseresults () {

	#
	# Testing - Dump aquired values
	#
	if [ x"$APISCRIPTVERBOSE" = x"true" ] ; then
	    # Verbose mode ON
	    
	    export outstring=
	    export outstring=$outstring"After: \n "
	    export outstring=$outstring"CLIparm_rootuser='$CLIparm_rootuser' \n "
	    export outstring=$outstring"CLIparm_user='$CLIparm_user' \n "
	    export outstring=$outstring"CLIparm_password='$CLIparm_password' \n "
	
	    export outstring=$outstring"CLIparm_websslport='$CLIparm_websslport' \n "
	    export outstring=$outstring"CLIparm_mgmt='$CLIparm_mgmt' \n "
	    export outstring=$outstring"CLIparm_domain='$CLIparm_domain' \n "
	    export outstring=$outstring"CLIparm_sessionidfile='$CLIparm_sessionidfile' \n "
	    export outstring=$outstring"CLIparm_logpath='$CLIparm_logpath' \n "

	    export outstring=$outstring"CLIparm_NoSystemObjects='$CLIparm_NoSystemObjects' \n "
	
	    if [ x"$script_use_export" = x"true" ] ; then
	        export outstring=$outstring"CLIparm_exportpath='$CLIparm_exportpath' \n "
	    fi
	    if [ x"$script_use_import" = x"true" ] ; then
	        export outstring=$outstring"CLIparm_importpath='$CLIparm_importpath' \n "
	    fi
	    if [ x"$script_use_delete" = x"true" ] ; then
	        export outstring=$outstring"CLIparm_deletepath='$CLIparm_deletepath' \n "
	    fi
	    if [ x"$script_use_csvfile" = x"true" ] ; then
	        export outstring=$outstring"CLIparm_csvpath='$CLIparm_csvpath' \n "
	    fi
	    
	    export outstring=$outstring"SHOWHELP='$SHOWHELP' \n "
	    export outstring=$outstring"APISCRIPTVERBOSE='$APISCRIPTVERBOSE' \n "
	    export outstring=$outstring"remains='$REMAINS'"
	    
	    echo
	    echo -e $outstring
	    echo
	    for i ; do echo - $i ; done
	    echo CLI parms - number $# parms $@
	    echo
	    
	fi

}


#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-04

# MODIFIED 2018-03-04 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# -------------------------------------------------------------------------------------------------
# dumprawcliparms
# -------------------------------------------------------------------------------------------------

dumprawcliparms () {
    #
    echo
    echo "Command line parameters before"
    echo number parms $#
    echo parms raw : \> $@ \<
    for k ; do echo $k $'\t' "${k}" ; done
    echo
}


#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-04

# MODIFIED 2018-03-04 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# -------------------------------------------------------------------------------------------------
# Testing
# -------------------------------------------------------------------------------------------------


#
# Testing
#
if [ x"$APISCRIPTVERBOSE" = x"true" ] ; then
    dumprawcliparms $@
fi


#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-04

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-03-05 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# -------------------------------------------------------------------------------------------------
# Help display proceedure
# -------------------------------------------------------------------------------------------------

# Show help information

doshowhelp () {
    #
    # Screen width template for sizing, default width of 80 characters assumed
    #
    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    echo
    echo -n $0' [-?][-v]|[-r]|[-u <admin_name>]|[-p <password>]]|[-P <web ssl port>]'
    echo -n '|[-m <server_IP>]|[-d <domain>]'
    echo -n '|[-s <session_file_filepath>]'
    echo -n '|[--SO|--NSO]'
    if [ x"$script_use_export" = x"true" ] ; then
        echo -n '|[-x <export_path>]'
    fi
    if [ x"$script_use_import" = x"true" ] ; then
        echo -n '|[-i <import_path>]'
    fi
    if [ x"$script_use_delete" = x"true" ] ; then
        echo -n '|[-k <delete_path>]'
    fi
    if [ x"$script_use_csvfile" = x"true" ] ; then
        echo -n '|[-c <csv_path>]'
    fi
    echo -n '|[-l <log_path>]'
    echo

    echo
    echo ' Script Version:  '$ScriptVersion'  Date:  '$ScriptDate
    echo
    echo ' Standard Command Line Parameters: '
    echo
    echo '  Show Help                  -? | --help'
    echo '  Verbose mode               -v | --verbose'
    echo
    echo '  Authenticate as root       -r | --root'
    echo '  Set Console User Name      -u <admin_name> | --user <admin_name> |'
    echo '                             -u=<admin_name> | --user=<admin_name>'
    echo '  Set Console User password  -p <password> | --password <password> |'
    echo '                             -p=<password> | --password=<password>'
    echo
    echo '  Set [web ssl] Port         -P <web-ssl-port> | --port <web-ssl-port> |'
    echo '                             -P=<web-ssl-port> | --port=<web-ssl-port>'
    echo '  Set Management Server IP   -m <server_IP> | --management <server_IP> |'
    echo '                             -m=<server_IP> | --management=<server_IP>'
    echo '  Set Management Domain      -d <domain> | --domain <domain> |'
    echo '                             -d=<domain> | --domain=<domain>'
    echo '  Set session file path      -s <session_file_filepath> |'
    echo '                             --session-file <session_file_filepath> |'
    echo '                             -s=<session_file_filepath> |'
    echo '                             --session-file=<session_file_filepath>'
    echo
    echo '  NO System Objects Export   --NSO | --no-system-objects  {default mode}'
    echo '  Export System Objects      --SO | --system-objects'
    echo
    echo '  Set log file path          -l <log_path> | --log-path <log_path> |'
    echo '                             -l=<log_path> | --log-path=<log_path>'
    echo
    if [ x"$script_use_export" = x"true" ] ; then
        echo '  Set export file path       -x <export_path> | --export <export_path> |'
        echo '                             -x=<export_path> | --export=<export_path>'
    fi
    if [ x"$script_use_import" = x"true" ] ; then
        echo '  Set import file path       -i <import_path> | --import-path <import_path> |'
        echo '                             -i=<import_path> | --import-path=<import_path>'
    fi
    if [ x"$script_use_delete" = x"true" ] ; then
        echo '  Set delete file path       -k <delete_path> | --delete-path <delete_path> |'
        echo '                             -k=<delete_path> | --delete-path=<delete_path>'
    fi
    if [ x"$script_use_csvfile" = x"true" ] ; then
        echo '  Set csv file path          -c <csv_path> | --csv <csv_path |'
        echo '                             -c=<csv_path> | --csv=<csv_path>'
    fi
    echo
    echo '  session_file_filepath = fully qualified file path for session file'
    echo '  log_path = fully qualified folder path for log files'

    if [ x"$script_use_export" = x"true" ] ; then
        echo '  export_path = fully qualified folder path for export file'
    fi
    if [ x"$script_use_import" = x"true" ] ; then
        echo '  import_path = fully qualified folder path for import files'
    fi
    if [ x"$script_use_delete" = x"true" ] ; then
        echo '  delete_path = fully qualified folder path for delete files'
    fi
    if [ x"$script_use_csvfile" = x"true" ] ; then
        echo '  csv_path = fully qualified file path for csv file'
    fi

    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    echo
    echo ' NOTE:  Only use Management Server IP (-m) parameter if operating from a '
    echo '        different host than the management host itself.'
    echo
    echo ' NOTE:  Use the Domain Name (text) with the Domain (-d) parameter when'
    echo '        Operating in Multi Domain Management environment.'
    echo '        Use the "Global" domain for the global domain objects.'
    echo '          Quotes NOT required!'
    echo '        Use the "System Data" domain for system domain objects.'
    echo '          Quotes REQUIRED!'
    echo
    echo ' NOTE:  System Objects are NOT exported in CSV or Full JSON dump mode!'
    echo '        Control of System Objects with --SO and --NSO only works with CSV or'
    echo '        Full JSON dump.  Standard JSON dump does not support selection of the'
    echo '        System Objects during operation, so all System Objects are collected'
    echo

    echo ' Example: General :'
    echo
    echo ' ]# '$ScriptName' -u fooAdmin -p voodoo -P 4434 -m 192.168.1.1 -d fooville -s "/var/tmp/id.txt" -l "/var/tmp/script_dump"'
    echo
    echo ' ]# '$ScriptName' -u fooAdmin -p voodoo -P 4434 -d Global --SO -s "/var/tmp/id.txt"'
    echo


    if [ x"$script_use_export" = x"true" ] ; then
        echo ' Example: Export:'
        echo
        echo ' ]# '$ScriptName' -u fooAdmin -p voodoo -P 4434 -m 192.168.1.1 -d fooville -s "/var/tmp/id.txt" -l "/var/tmp/script_dump" -x "/var/tmp/script_dump/export"'
        echo
    fi

    if [ x"$script_use_import" = x"true" ] ; then
        echo ' Example: Import:'
        echo
        echo ' ]# '$ScriptName' -u fooAdmin -p voodoo -P 4434 -m 192.168.1.1 -d fooville -s "/var/tmp/id.txt" -l "/var/tmp/script_dump" -i "/var/tmp/import"'
        echo
    fi
    
    if [ x"$script_use_delete" = x"true" ] ; then
        echo ' Example: Delete:'
        echo
        echo ' ]# '$ScriptName' -u fooAdmin -p voodoo -P 4434 -m 192.168.1.1 -d fooville -s "/var/tmp/id.txt" -l "/var/tmp/script_dump" -x "/var/tmp/script_dump/export" -k "/var/tmp/delete"'
        echo
    fi
    
    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

    echo
    return 1
}

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-05

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-03-04 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# -------------------------------------------------------------------------------------------------
# Process command line parameters and set appropriate values
# -------------------------------------------------------------------------------------------------

while [ -n "$1" ]; do
    # Copy so we can modify it (can't modify $1)
    OPT="$1"

    # testing
    #echo 'OPT = '$OPT
    #

    # Detect argument termination
    if [ x"$OPT" = x"--" ]; then
        # testing
        # echo "Argument termination"
        #
        
        shift
        for OPT ; do
            REMAINS="$REMAINS \"$OPT\""
            done
            break
        fi
    # Parse current opt
    while [ x"$OPT" != x"-" ] ; do
        case "$OPT" in
            # Help and Standard Operations
            '-?' | --help )
                SHOWHELP=true
                ;;
            '-v' | --verbose )
                export APISCRIPTVERBOSE=true
                ;;
            # Handle immediate opts like this
            -r | --root )
                CLIparm_rootuser=true
                ;;
#           -f | --force )
#               FORCE=true
#               ;;
            # Handle --flag=value opts like this
            -u=* | --user=* )
                CLIparm_user="${OPT#*=}"
                #shift
                ;;
            -p=* | --password=* )
                CLIparm_password="${OPT#*=}"
                #shift
                ;;
            -P=* | --port=* )
                CLIparm_websslport="${OPT#*=}"
                #shift
                ;;
            -m=* | --management=* )
                CLIparm_mgmt="${OPT#*=}"
                #shift
                ;;
            -d=* | --domain=* )
                CLIparm_domain="${OPT#*=}"
                #shift
                ;;
            -s=* | --session-file=* )
                CLIparm_sessionidfile="${OPT#*=}"
                #shift
                ;;
            -l=* | --log-path=* )
                CLIparm_logpath="${OPT#*=}"
                #shift
                ;;
            -x=* | --export=* )
                CLIparm_exportpath="${OPT#*=}"
                #shift
                ;;
            -i=* | --import-path=* )
                CLIparm_importpath="${OPT#*=}"
                #shift
                ;;
            -k=* | --delete-path=* )
                CLIparm_deletepath="${OPT#*=}"
                #shift
                ;;
            -c=* | --csv=* )
                CLIparm_csvpath="${OPT#*=}"
                #shift
                ;;
            # and --flag value opts like this
            -u* | --user )
                CLIparm_user="$2"
                shift
                ;;
            -p* | --password )
                CLIparm_password="$2"
                shift
                ;;
            -P* | --port )
                CLIparm_websslport="$2"
                shift
                ;;
            -m* | --management )
                CLIparm_mgmt="$2"
                shift
                ;;
            -d* | --domain )
                CLIparm_domain="$2"
                shift
                ;;
            -s* | --session-file )
                CLIparm_sessionidfile="$2"
                shift
                ;;
            -l* | --log-path )
                CLIparm_logpath="$2"
                shift
                ;;
            -x* | --export )
                CLIparm_exportpath="$2"
                shift
                ;;
            -i* | --import-path )
                CLIparm_importpath="$2"
                shift
                ;;
            -k* | --delete-path )
                CLIparm_deletepath="$2"
                shift
                ;;
            -c* | --csv )
                CLIparm_csvpath="$2"
                shift
                ;;
            --SO | --system-objects )
                CLIparm_NoSystemObjects=false
                shift
                ;;
            --NSO | --no-system-objects )
                CLIparm_NoSystemObjects=true
                shift
                ;;
            # Anything unknown is recorded for later
            * )
                REMAINS="$REMAINS \"$OPT\""
                break
                ;;
        esac
        # Check for multiple short options
        # NOTICE: be sure to update this pattern to match valid options
        # Remove any characters matching "-", and then the values between []'s
        #NEXTOPT="${OPT#-[upmdsor?]}" # try removing single short opt
        NEXTOPT="${OPT#-[vrf?]}" # try removing single short opt
        if [ x"$OPT" != x"$NEXTOPT" ] ; then
            OPT="-$NEXTOPT"  # multiple short opts, keep going
        else
            break  # long form, exit inner loop
        fi
    done
    # Done with that param. move to next
    shift
done
# Set the non-parameters back into the positional parameters ($1 $2 ..)
eval set -- $REMAINS

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-04

# MODIFIED 2018-03-04 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

export SHOWHELP=$SHOWHELP
export CLIparm_websslport=$CLIparm_websslport
export CLIparm_rootuser=$CLIparm_rootuser
export CLIparm_user=$CLIparm_user
export CLIparm_password=$CLIparm_password
export CLIparm_mgmt=$CLIparm_mgmt
export CLIparm_domain=$CLIparm_domain
export CLIparm_sessionidfile=$CLIparm_sessionidfile
export CLIparm_logpath=$CLIparm_logpath

export CLIparm_NoSystemObjects=`echo "$CLIparm_NoSystemObjects" | tr '[:upper:]' '[:lower:]'`

export CLIparm_exportpath=$CLIparm_exportpath
export CLIparm_importpath=$CLIparm_importpath
export CLIparm_deletepath=$CLIparm_deletepath

export CLIparm_csvpath=$CLIparm_csvpath

export REMAINS=$REMAINS

dumpcliparmparseresults $@

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-04

# MODIFIED 2018-03-04 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# -------------------------------------------------------------------------------------------------
# Handle request for help and exit
# -------------------------------------------------------------------------------------------------

#
# Was help requested, if so show it and exit
#
if [ x"$SHOWHELP" = x"true" ] ; then
    # Show Help
    doshowhelp
    exit
fi

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-04

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-03-04 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# =================================================================================================
# END:  Command Line Parameter Handling and Help
# =================================================================================================
# =================================================================================================

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/ MODIFIED 2018-03-04


# =================================================================================================
# =================================================================================================
# START:  Setup Standard Parameters
# =================================================================================================

# MODIFIED 2017-08-28 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

export gaiaversion=$(clish -c "show version product" | cut -d " " -f 6)

if [ x"$APISCRIPTVERBOSE" = x"true" ] ; then
    echo 'Gaia Version : $gaiaversion = '$gaiaversion
    echo
fi


export DATE=`date +%Y-%m-%d-%H%M%Z`

if [ x"$APISCRIPTVERBOSE" = x"true" ] ; then
    echo 'Date Time Group   :  '$DATE
    echo
fi

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2017-08-28


# =================================================================================================
# END:  Setup Standard Parameters
# =================================================================================================
# =================================================================================================


# MODIFIED 2018-03-04-2 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# =================================================================================================
# =================================================================================================
# START:  Setup Login Parameters and Login to Mgmt_CLI
# =================================================================================================


if [ x"$CLIparm_user" != x"" ] ; then
    export APICLIadmin=$CLIparm_user
else
    export APICLIadmin=administrator
fi

if [ x"$CLIparm_sessionidfile" != x"" ] ; then
    export APICLIsessionfile=$CLIparm_sessionidfile
else
    export APICLIsessionfile=id.txt
fi


#
# Testing - Dump aquired values
#
echo 'APICLIadmin       :  '$APICLIadmin
echo 'APICLIsessionfile :  '$APICLIsessionfile
echo

loginstring=
mgmttarget=
domaintarget=

if [ x"$CLIparm_websslport" != x"" ] ; then
    # Handle web ssl port parameter for login string
    if [ x"$loginstring" != x"" ] ; then
        loginstring=$loginstring" --port $CLIparm_websslport"
    else
        loginstring="--port $CLIparm_websslport"
    fi
else
    loginstring=$loginstring
fi

if [ x"$CLIparm_rootuser" = x"true" ] ; then

    # Handle Root User
    if [ x"$loginstring" != x"" ] ; then
        loginstring=$loginstring" --root true"
    else
        loginstring="--root true"
    fi

    if [ x"$CLIparm_domain" != x"" ] ; then
    # Handle domain parameter for login string
        if [ x"$loginstring" != x"" ] ; then
            loginstring=$loginstring" -d \"$CLIparm_domain\""
        else
            loginstring="loginstring \"$CLIparm_domain\""
        fi
    else
        loginstring=$loginstring
    fi

else

    # Handle admin user parameter
    if [ x"$APICLIadmin" != x"" ] ; then
        if [ x"$loginstring" != x"" ] ; then
            loginstring=$loginstring" user $APICLIadmin"
        else
            loginstring="user $APICLIadmin"
        fi
    else
        loginstring=$loginstring
    fi
    
    # Handle password parameter
    if [ x"$CLIparm_password" != x"" ] ; then
        if [ x"$loginstring" != x"" ] ; then
            loginstring=$loginstring" password \"$CLIparm_password\""
        else
            loginstring="password \"$CLIparm_password\""
        fi
    else
        loginstring=$loginstring
    fi

    if [ x"$CLIparm_domain" != x"" ] ; then
    # Handle domain parameter for login string
        if [ x"$loginstring" != x"" ] ; then
            loginstring=$loginstring" domain \"$CLIparm_domain\""
        else
            loginstring="loginstring \"$CLIparm_domain\""
        fi
    else
        loginstring=$loginstring
    fi

fi

# Handle management server parameter for mgmt_cli parms
if [ x"$CLIparm_mgmt" != x"" ] ; then
    if [ x"$mgmttarget" != x"" ] ; then
        mgmttarget=$mgmttarget" -m \"$CLIparm_mgmt\""
    else
        mgmttarget="-m \"$CLIparm_mgmt\""
    fi
else
    mgmttarget=$mgmttarget
fi

#   Handle domain parameter for mgmt_cli parms
if [ x"$CLIparm_domain" != x"" ] ; then
    if [ x"$domaintarget" != x"" ] ; then
        domaintarget=$domaintarget" -d \"$CLIparm_domain\""
    else
        domaintarget="-d \"$CLIparm_domain\""
    fi
else
    domaintarget=$domaintarget
fi

echo
echo 'mgmt_cli Login!'
echo
echo 'Login to mgmt_cli as '$APICLIadmin' and save to session file :  '$APICLIsessionfile
echo

#
# Testing - Dump login string bullt from parameters
#
if [ x"$APISCRIPTVERBOSE" = x"true" ] ; then
    echo 'Execute login with loginstring '\"$loginstring\"
    echo 'Execute operations with domaintarget '\"$domaintarget\"
    echo 'Execute operations with mgmttarget '\"$mgmttarget\"
    echo
fi

if [ x"$mgmttarget" = x"" ] ; then
    mgmt_cli login $loginstring > $APICLIsessionfile
else
    mgmt_cli login $loginstring $mgmttarget > $APICLIsessionfile
fi
EXITCODE=$?
if [ "$EXITCODE" != "0" ] ; then
    
    echo
    echo "mgmt_cli login error!"
    echo
    cat $APICLIsessionfile
    echo
    echo "Terminating script..."
    echo
    exit 255

else
    
    echo "mgmt_cli login success!"
    echo
    cat $APICLIsessionfile
    echo
    
fi


# =================================================================================================
# END:  Setup Login Parameters and Login to Mgmt_CLI
# =================================================================================================
# =================================================================================================

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-04-2
# MODIFIED 2018-03-05 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# =================================================================================================
# =================================================================================================
# START:  Setup CLI Parameters
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# Set parameters for Main operations - CLI
# -------------------------------------------------------------------------------------------------

if [ x"$CLIparm_logpath" != x"" ] ; then
    export APICLIlogpathroot=$CLIparm_logpath
else
    export APICLIlogpathroot=./dump
fi

export APICLIlogpathbase=$APICLIlogpathroot/$DATE

if [ ! -r $APICLIlogpathroot ] ; then
    mkdir $APICLIlogpathroot
fi
if [ ! -r $APICLIlogpathbase ] ; then
    mkdir $APICLIlogpathbase
fi

export APICLIlogfilepath=$APICLIlogpathbase/$ScriptName'_'$APIScriptVersion'_'$DATE.log

if [ x"$script_use_export" = x"true" ] ; then
    if [ x"$CLIparm_exportpath" != x"" ] ; then
        export APICLIpathroot=$CLIparm_exportpath
    else
        export APICLIpathroot=./dump
    fi
  
    export APICLIpathbase=$APICLIpathroot/$DATE
    
    if [ ! -r $APICLIpathroot ] ; then
        mkdir $APICLIpathroot
    fi
    if [ ! -r $APICLIpathbase ] ; then
        mkdir $APICLIpathbase
    fi
fi

if [ x"$script_use_import" = x"true" ] ; then
    if [ x"$CLIparm_importpath" != x"" ] ; then
        export APICLICSVImportpathbase=$CLIparm_importpath
    else
        export APICLICSVImportpathbase=./import.csv
    fi
    
    if [ ! -r $APICLIpathbase/import ] ; then
        mkdir $APICLIpathbase/import
    fi
fi

if [ x"$script_use_delete" = x"true" ] ; then
    if [ x"$CLIparm_deletepath" != x"" ] ; then
        export APICLICSVDeletepathbase=$CLIparm_deletepath
    else
        export APICLICSVDeletepathbase=./delete.csv
    fi
    
    if [ ! -r $APICLIpathbase/delete ] ; then
        mkdir $APICLIpathbase/delete
    fi
fi

if [ x"$script_use_csvfile" = x"true" ] ; then
    if [ x"$CLIparm_csvpath" != x"" ] ; then
        export APICLICSVcsvpath=$CLIparm_csvpath
    else
        export APICLICSVcsvpath=./domains.csv
    fi
fi

if [ x"$script_dump_csv" = x"true" ] ; then
    if [ ! -r $APICLIpathbase/csv ] ; then
        mkdir $APICLIpathbase/csv
    fi
fi

if [ x"$script_dump_full" = x"true" ] ; then
    if [ ! -r $APICLIpathbase/full ] ; then
        mkdir $APICLIpathbase/full
    fi
fi

if [ x"$script_dump_standard" = x"true" ] ; then
    if [ ! -r $APICLIpathbase/standard ] ; then
        mkdir $APICLIpathbase/standard
    fi
fi

#export NoSystemObjects=`echo "$CLIparm_NoSystemObjects" | tr '[:upper:]' '[:lower:]'`
if [ x"`echo "$CLIparm_NoSystemObjects" | tr '[:upper:]' '[:lower:]'`" = x"false" ] ; then
    export NoSystemObjects=false
else
    export NoSystemObjects=true
fi
    
# =================================================================================================
# END:  Setup CLI Parameters
# =================================================================================================
# =================================================================================================

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-05

# =================================================================================================
# -------------------------------------------------------------------------------------------------
# =================================================================================================
# START:  Main operations - 
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# Set parameters for Main operations
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# START:  Main operations
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# Start executing Main operations
# -------------------------------------------------------------------------------------------------

#
# shell meat
#


# meat START

echo Do something...
echo

#export MgmtCLI_Base_OpParms="--format json -s $APICLIsessionfile"
#export MgmtCLI_IgnoreErr_OpParms="ignore-warnings true ignore-errors true --ignore-errors true"
#
#export MgmtCLI_Show_OpParms="details-level \"$APICLIdetaillvl\" $MgmtCLI_Base_OpParms"
#
#if [ $(expr $currentapiversion '>=' 1.1 ) ] ; then
#    export MgmtCLI_Add_OpParms="set-if-exists true $MgmtCLI_IgnoreErr_OpParms $MgmtCLI_Base_OpParms"
#else
#    export MgmtCLI_Add_OpParms="$MgmtCLI_IgnoreErr_OpParms $MgmtCLI_Base_OpParms"
#fi
#
#export MgmtCLI_Set_OpParms="$MgmtCLI_IgnoreErr_OpParms $MgmtCLI_Base_OpParms"
#
#export MgmtCLI_Delete_OpParms="details-level \"$APICLIdetaillvl\" $MgmtCLI_IgnoreErr_OpParms $MgmtCLI_Base_OpParms"
#
#mgmt_cli delete $APICLIobjecttype --batch $APICLIDeleteCSVfile $MgmtCLI_Delete_OpParms > $OutputPath
#mgmt_cli show $APICLIobjecttype limit $APICLIObjectLimit offset $currentoffset $MgmtCLI_Show_OpParms | $JQ '.objects[] | [ '"$CSVJQparms"' ] | @csv' -r >> $APICLICSVfiledata
#mgmt_cli add $APICLIobjecttype --batch $APICLIImportCSVfile $MgmtCLI_Add_OpParms > $OutputPath
#mgmt_cli set $APICLIobjecttype --batch $APICLIImportCSVfile ignore-warnings true ignore-errors true --ignore-errors true --format json -s $APICLIsessionfile > $OutputPath


#
# Examples
#
#mgmt_cli show hosts details-level "standard" --format json -s $APICLIsessionfile > dump/$DATE/hosts_dump_standard_$DATE.txt
#mgmt_cli show hosts details-level "full" --format json -s $APICLIsessionfile > dump/$DATE/hosts_dump_full_$DATE.txt
#mgmt_cli add host --batch "$APICLICSVImportpathbase" ignore-warnings true ignore-errors true details-level "full" --ignore-errors true --format json -s $APICLIsessionfile > dump/$DATE/hosts_dump_full_$DATE.txt
#mgmt_cli set network --batch "$APICLICSVImportpathbase" ignore-warnings true ignore-errors true details-level "full" --ignore-errors true --format json -s $APICLIsessionfile > dump/$DATE/hosts_dump_full_$DATE.txt
#

# meat END


# =================================================================================================
# END:  Main operations - 
# =================================================================================================
# -------------------------------------------------------------------------------------------------
# =================================================================================================


# =================================================================================================
# =================================================================================================
# START:  Publish, Cleanup, and Dump output
# =================================================================================================


# MODIFIED 2017-07-21 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# -------------------------------------------------------------------------------------------------
# Publish Changes
# -------------------------------------------------------------------------------------------------


if [ x"$script_use_publish" = x"true" ] ; then
    echo
    echo 'Publish changes!'
    echo
    mgmt_cli publish -s $APICLIsessionfile
    echo
else
    echo
    echo 'Nothing to Publish!'
    echo
fi

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2017-07-21

# -------------------------------------------------------------------------------------------------
# Logout from mgmt_cli, also cleanup session file
# -------------------------------------------------------------------------------------------------

echo
echo 'Logout of mgmt_cli!  Then remove session file.'
echo
mgmt_cli logout -s $APICLIsessionfile

rm $APICLIsessionfile

# MODIFIED 2018-03-04 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# -------------------------------------------------------------------------------------------------
# Clean-up and exit
# -------------------------------------------------------------------------------------------------

echo 'CLI Operations Completed'

if [ x"$APISCRIPTVERBOSE" = x"true" ] ; then
    # Verbose mode ON

    echo
    #echo "Files in >$apiclipathroot<"
    #ls -alh $apiclipathroot
    #echo

    if [ "$APICLIlogpathbase" != "$APICLIpathbase" ] ; then
        echo "Files in >$APICLIlogpathbase<"
        ls -alhR $APICLIpathbase
        echo
    fi
    
    echo "Files in >$APICLIpathbase<"
    ls -alhR $APICLIpathbase
    echo
fi

echo
echo "Results in directory $APICLIpathbase"
echo "Log output in file $APICLIlogfilepath"
echo

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-03-04


# =================================================================================================
# END:  Publish, Cleanup, and Dump output
# =================================================================================================
# =================================================================================================


