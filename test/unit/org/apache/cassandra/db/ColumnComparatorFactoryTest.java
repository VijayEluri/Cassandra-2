/*
* Licensed to the Apache Software Foundation (ASF) under one
* or more contributor license agreements.  See the NOTICE file
* distributed with this work for additional information
* regarding copyright ownership.  The ASF licenses this file
* to you under the Apache License, Version 2.0 (the
* "License"); you may not use this file except in compliance
* with the License.  You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an
* "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
* KIND, either express or implied.  See the License for the
* specific language governing permissions and limitations
* under the License.
*/
package org.apache.cassandra.db;

import java.util.Comparator;

import org.junit.Test;

import static org.apache.cassandra.Util.column;

public class ColumnComparatorFactoryTest {
    public Comparator<IColumn> nameComparator = ColumnComparatorFactory.getComparator(ColumnComparatorFactory.ComparatorType.NAME);

    @Test
    public void testLT() {
        IColumn col1 = column("Column-8", "", 0);
        IColumn col2 = column("Column-9", "", 0);
        assert nameComparator.compare(col1, col2) < 0;
    }

    @Test
    public void testGT() {
        IColumn col1 = column("Column-9", "", 0);
        IColumn col2 = column("Column-10", "", 0);
        // tricky -- remember we're comparing _lexically_
        assert nameComparator.compare(col1, col2) > 0;
	}
}
