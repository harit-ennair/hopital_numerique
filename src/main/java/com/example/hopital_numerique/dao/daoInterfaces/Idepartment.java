package com.example.hopital_numerique.dao.daoInterfaces;

import com.example.hopital_numerique.model.Department;
import java.util.List;

public interface Idepartment {
    void save(Department department);
    void update(Department department);
    void delete(int departmentId);
    List<Department> findAll();
    Department findById(int departmentId);
    Department findByName(String name);
}
