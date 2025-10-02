#js
#!/bin/bash
#/WebSphere/scripts/middleware/ace/AllSslPropEgs.sh
brk=$1
eg=$2

LOG=AllEGProperties.$brk.$eg

>$LOG
ENO=1
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
   echo -e "--------------------------------------------------------------------------------------------------------$tag Prop of  $brk - $eg($ENO)" >> $LOG
   #echo -e "mqsireportproperties brk -e eg -o ComIbmJVMManager -r | grep store"  >> $LOG
   #mqsireportproperties $brk -e $eg -o ComIbmJVMManager -r | grep store >> $LOG
   #echo -e "mqsireportproperties brk -e eg -o HTTPSConnector -a | grep -i port" >> $LOG
   #mqsireportproperties $brk -e $eg -o HTTPSConnector -a | grep -i port >> $LOG
   #echo -e "mqsireportproperties brk -e eg -o HTTPConnector -a | grep -i Port" >> $LOG
   #mqsireportproperties $brk -e $eg -o HTTPConnector -a | grep -i Port  >> $LOG
   #echo -e "mqsireportproperties brk -e eg -o HTTPSConnector -a | grep -i store" >> $LOG
   #mqsireportproperties $brk -e $eg -o HTTPSConnector -a | grep -i store >> $LOG
   #echo -e "mqsireportproperties brk -e eg -o HTTPConnector -a | grep -i store" >> $LOG
   #mqsireportproperties $brk -e $eg -o HTTPConnector -a | grep -i store >> $LOG
   echo -e "mqsireportproperties brk -e eg -o ExecutionGroup -a | grep httpNodesUseEmbeddedListener" >> $LOG
   mqsireportproperties $brk -e $eg -o ExecutionGroup -a | grep httpNodesUseEmbeddedListener >> $LOG
   echo -e "mqsireportproperties brk -e eg -o HTTPSConnector -a  | grep -i ssl" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -a  | grep -i ssl >> $LOG
   ((ENO=ENO+1))
done 


#1. mqsireportproperties IIBQAAA34 -e esb_magento_latam -o AllReportableEntityNames -r


#ReportableEntityName='ParserManager'
#ReportableEntityName='ExecutionGroup'
#ReportableEntityName='JVM'
#ReportableEntityName='DatabaseConnectionManager'
#ReportableEntityName='CLR'
#ReportableEntityName='odm'
#ReportableEntityName='HTTPConnector'
#ReportableEntityName='HTTPSConnector'
#ReportableEntityName='CallableFlowManager'
#ReportableEntityName='ActivityLogManager'
#ReportableEntityName='AsyncHandleManager'
#ReportableEntityName='XMLNSC'
#ReportableEntityName='IIBSwitchManager'
#ReportableEntityName='JSON'
#ReportableEntityName='MQConnectionManager'
#ReportableEntityName='Nodejs'
#ReportableEntityName='SOAPPipelineManager'
#ReportableEntityName='XPathCache'
#ReportableEntityName='ContentBasedFiltering'
#ReportableEntityName='ExceptionLog'
#ReportableEntityName='flow-thread-reporter'
#ReportableEntityName='GlobalCache'
#ReportableEntityName='GroupDirector'
#ReportableEntityName='SocketConnectionManager'
#ReportableEntityName='FTEAgent'
#ReportableEntityName='ESQL'

