#!/usr/local/bin/thrift --java --php --py
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Interface definition for Cassandra Service
#

namespace java org.apache.cassandra.service
namespace cpp org.apache.cassandra
namespace csharp Apache.Cassandra
namespace py cassandra
namespace php cassandra
namespace perl Cassandra

# Thrift.rb has a bug where top-level modules that include modules 
# with the same name are not properly referenced, so we can't do
# Cassandra::Cassandra::Client.
namespace rb CassandraThrift

#
# structures
#

struct Column {
   1: binary                        name,
   2: binary                        value,
   3: i64                           timestamp,
}

typedef map<string, list<Column>>   column_family_map

struct BatchMutation {
   1: string                        key,
   2: column_family_map             cfmap,
}

struct SuperColumn {
   1: binary                        name,
   2: list<Column>                  columns,
}

typedef map<string, list<SuperColumn>> SuperColumnFamilyMap

struct BatchMutationSuper {
   1: string                        key,
   2: SuperColumnFamilyMap          cfmap,
}


typedef list<map<string, string>>   ResultSet

#
# Exceptions
#

# a specific column was requested that does not exist
exception NotFoundException {
}

# invalid request (keyspace / CF does not exist, etc.)
exception InvalidRequestException {
    1: string why
}

# not all the replicas required could be created / read
exception UnavailableException {
}

# (note that internal server errors will raise a TApplicationException, courtesy of Thrift)


#
# service api
#

enum ConsistencyLevel {
    ZERO = 0,
    ONE = 1,
    QUORUM = 2,
    ALL = 3,
}

struct ColumnParent {
    3: string          column_family,
    4: optional binary super_column,
}

struct ColumnPath {
    3: string          column_family,
    4: optional binary super_column,
    5: optional binary column,
}

struct SliceRange {
    1: binary          start,
    2: binary          finish,
    3: bool            reversed=0,
    4: i32             count=100,
}

struct SlicePredicate {
    1: optional list<binary> column_names,
    2: optional SliceRange   slice_range,
}

struct ColumnOrSuperColumn {
    1: optional Column column,
    2: optional SuperColumn super_column,
}


service Cassandra {
  list<ColumnOrSuperColumn> get_slice(1:string keyspace, 2:string key, 3:ColumnParent column_parent, 4:SlicePredicate predicate, 5:ConsistencyLevel consistency_level=1)
  throws (1: InvalidRequestException ire, 2: NotFoundException nfe),

  ColumnOrSuperColumn get(1:string keyspace, 2:string key, 3:ColumnPath column_path, 4:ConsistencyLevel consistency_level=1)
  throws (1: InvalidRequestException ire, 2: NotFoundException nfe),

  i32 get_count(1:string keyspace, 2:string key, 3:ColumnParent column_parent, 5:ConsistencyLevel consistency_level=1)
  throws (1: InvalidRequestException ire),

  void     insert(1:string keyspace, 2:string key, 3:ColumnPath column_path, 4:binary value, 5:i64 timestamp, 6:ConsistencyLevel consistency_level=0)
  throws (1: InvalidRequestException ire, 2: UnavailableException ue),

  void     batch_insert(1:string keyspace, 2:BatchMutation batch_mutation, 3:ConsistencyLevel consistency_level=0)
  throws (1: InvalidRequestException ire, 2: UnavailableException ue),

  void           remove(1:string keyspace, 2:string key, 3:ColumnPath column_path, 4:i64 timestamp, 5:ConsistencyLevel consistency_level=0)
  throws (1: InvalidRequestException ire, 2: UnavailableException ue),

  void     batch_insert_super_column(1:string keyspace, 2:BatchMutationSuper batch_mutation_super, 3:ConsistencyLevel consistency_level=0)
  throws (1: InvalidRequestException ire, 2: UnavailableException ue),

  # range query: returns matching keys
  list<string>   get_key_range(1:string keyspace, 2:string column_family, 3:string start="", 4:string finish="", 5:i32 count=100)
  throws (1: InvalidRequestException ire),

  /////////////////////////////////////////////////////////////////////////////////////
  // The following are beta APIs being introduced for CLI and/or CQL support.        //
  // These are still experimental, and subject to change.                            //
  /////////////////////////////////////////////////////////////////////////////////////

  // get property whose value is of type "string"
  string         get_string_property(1:string property),

  // get property whose value is list of "strings"
  list<string>   get_string_list_property(1:string property),

  // describe specified keyspace
  map<string, map<string, string>>  describe_keyspace(1:string keyspace)
  throws (1: NotFoundException nfe),
}

