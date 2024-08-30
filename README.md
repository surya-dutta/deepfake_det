# It Takes a Village to Build a Robot: An Empirical Study of The ROS Ecosystem - Replication Package
----------------------

This package includes the dataset and scripts required to replicate the results of article "It Takes a Village to Build a Robot: An Empirical Study of The ROS Ecosystem" in proceedings of International Conference on Software Maintenance and Evolution (ICSME) 2020.
You can cite this paper using the following BibTeX reference:
```
@inproceedings{kolak20ros,
  title={It Takes a Village to Build a Robot: An Empirical Study of The {ROS} Ecosystem},
  author={Kolak, Sophia and Afzal, Afsoon and {Le Goues}, Claire and Hilton, Michael and Timperley, Christopher S.},
  booktitle={International Conference on Software Maintenance and Evolution},
  series={ICSME'20},
  year={2020},
}
```

## Scripts

Here we describe the scripts included in the dataset that were used to build the most critical tables in the database.

### build_all_versions.py

Builds the mysql table `all_versions`. The script finds every version of any ROS package that has been committed to the kinetic distribution and records key information about it from the `distribution.yaml` file. 

### build_snapshot.py

Takes a datetime of the form YYYY-MM-DD and creates a `snapshot` of the ROS ecosystem at that point in time using the two tables `all_versions` and `kinetic_depends`. A snapshot simply records dependencies between packages as they existed at the given date.  Although ROS packages do not explicitly specify which version of another package they depend on, for the sake of capturing the state of the distribution in as much detail as possible, we assumed that each package depended on the most recent release at that time. 

### get_depends.py

Builds the mysql table `kinetic_depends` by parsing the `package.xml` file of every package in the `all_versions` table for its explicitly stated dependencies. In rare cases (~2% of the time) a version of the dependency is specified. When this happened, it was recorded in the `version` field, along with its operator. (This practice is explained at https://www.ros.org/reps/rep-0127.html#id13)

## ros_ecosystem_db.sql 

Here we describe each of the tables contained in the sql file 

### all_versions 

```all_versions
+------------------+
| Field            |
+------------------+
| id               | 
| name             | 
| distro           | 
| version          | 
| type             | --> release or source
| release_datetime | --> when the package was committed to the ROS kinetic distribution
| rosdistro_commit | --> the commit sha when the package was first added
| repo_url         | 
| is_stack         | --> AKA metapackage
| is_sub_pack      | --> for packages that are wrapped in a metapackage
| parent_id        | --> the stack/metapackage that a sub_pack belongs to
+------------------+
```

### git_client

records informaiton about ROS-client dataset returned by the Github API such as stars, forks, language, size, etc.

### git_data

records information about ROS-distro dataset returned by the Github API (stars,forks,creation date,etc.)

### kinetic_depends 

```
kinetic_depends
+------------+
| Field      | 
+------------+
| id         | 
| parent_id  | --> foreign key to the all_versions table 
| child      | --> name of the dependency from the package.xml file
| dep_type   | --> "run_depend", "build_depend", "exec_depend", etc.
| version    |  
| version_op | --> "version operator", greater than, less than, geq, etc.
+------------+
```

### now_versions 

Same table format as all_versions, but only records information about current versions of ROS packages (or those that were current in September 2019)

### now_versions_src

records the GH organization and organization type for all current versions of ROS packages

### repo 

repo, repo_package, and repo_package_deps are the three tables used to map the dependencies in the ROS-client dataset. The repo table defines repositories, which can contain multiple ROS packages. Each ROS package has an entry in the repo_package table. Finally, each package has some number of dependencies, recorded in the repo_package_deps table. The schema of each table is shown below

```
repo
+-------+
| Field |
+-------+
| id    | 
| name  | 
| url   | 
+--------
```

### repo_package

```
repo_package   
+--------------+
| Field        |
+--------------+
| id           |
| repo_id      | --> foreign key to repo table 
| package_name | --> parsed from name tag in package.xml file
| url_file     | --> raw git url to package.xml file
+--------------+
```

### repo_package_deps

```
repo_package_deps
+-----------------+
| Field           | 
+-----------------+
| id              |
| repo_package_id | --> foreign key to repo_package table
| dep_name        |
| dep_type        | --> same meaning as above
+-----------------+
```

### ros_devs

Contains the username of every GH user who has committed to the ROS-distro, along with the number of commits they made to both the core and the overall distro

### rosdistro_commits

Stores the datetime and hash of every commit made to the ROS-distro 

### snapshot_depends

```
snapshot_depends
+-------------+
| Field       | 
+-------------+
| id          | 
| id_from     | --> foreign key to the all_versions table 
| id_to       | --> foregin key to the all_versions table
| depend_id   | --> foreign key to the kinetic_depends table (for packages outside of the distro)
| commit_date | --> finds commit_date from all_versions closest to datetime given in program
| commit_sha  | --> finds commit sha from all_versions with date closest to one given 
| dep_type    | --> same meaning as above
+-------------+
```
"# deepfake_det" 
