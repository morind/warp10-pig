-- Name your script Load_HBase_Customers.pig
-- Load dataset 'customers' from HDFS location

raw_data = LOAD 'hdfs:/user/training/customers' USING PigStorage(',') AS (
           custno:chararray,
           firstname:chararray,
           lastname:chararray,
           age:int,
           profession:chararray
);

-- To dump the data from PIG Storage to stdout
/* dump raw_data; */

-- Use HBase storage handler to map data from PIG to HBase
--NOTE: In this case, custno (first unique column) will be considered as row key.

STORE raw_data INTO 'hbase://customers' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'cdata:first,
 cdata:last,
 cdata:age,
 cdata:prof'
);
