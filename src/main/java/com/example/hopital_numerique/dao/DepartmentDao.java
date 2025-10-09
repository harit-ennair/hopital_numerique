package com.example.hopital_numerique.dao;

import com.example.hopital_numerique.dao.daoInterfaces.Idepartment;
import com.example.hopital_numerique.model.Department;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.List;

public class DepartmentDao implements Idepartment {
    @Override
    public void save(Department department) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(department);
        em.getTransaction().commit();
        em.close();
        emf.close();

    }

    @Override
    public void update(Department department) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(department);
        em.getTransaction().commit();
        em.close();
        emf.close();

    }

    @Override
    public void delete(int departmentId) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Department department = em.find(Department.class, departmentId);
        if (department != null) {
            em.getTransaction().begin();
            em.remove(department);
            em.getTransaction().commit();
        }
        em.close();
        emf.close();

    }

    @Override
    public List<Department> findAll() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Department> departments = em.createQuery("SELECT d FROM Department d", Department.class).getResultList();
        em.close();
        emf.close();
        return departments;
    }

    @Override
    public Department findById(int departmentId) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Department department = em.find(Department.class, departmentId);
        em.close();
        emf.close();
        return department;
    }

    @Override
    public Department findByName(String name) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Department department = em.createQuery("SELECT d FROM Department d WHERE d.name = :name", Department.class)
                .setParameter("name", name)
                .getSingleResult();
        em.close();
        emf.close();
        return department;
    }
}
