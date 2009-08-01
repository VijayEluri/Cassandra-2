/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.cassandra.io;

import java.io.IOException;
import java.util.List;
import java.util.SortedSet;

/**
 * Interface to read from the SequenceFile abstraction.
 * Author : Avinash Lakshman ( alakshman@facebook.com) & Prashant Malik ( pmalik@facebook.com )
 */

public interface IFileReader
{
    public String getFileName();
    public long getEOF() throws IOException;
    public long getCurrentPosition() throws IOException;
    public void seek(long position) throws IOException;
    public boolean isEOF() throws IOException;

    /**
     * This method dumps the next key/value into the DataOuputStream
     * passed in. Always use this method to query for application
     * specific data as it will have indexes.
     *
     * @param key - key we are interested in.
     * @param bufOut - DataOutputStream that needs to be filled.
     * @param columnFamilyName The name of the column family only without the ":"
     * @param columnNames - The list of columns in the cfName column family
     * 					     that we want to return
    */
    public long next(String key, DataOutputBuffer bufOut, String columnFamilyName, SortedSet<byte[]> columnNames, long position) throws IOException;

    /**
     * Close the file after reading.
     * @throws IOException
     */
    public void close() throws IOException;
}
