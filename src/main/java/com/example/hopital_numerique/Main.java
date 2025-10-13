package com.example.hopital_numerique;

import com.example.hopital_numerique.dao.DepartmentDao;
import com.example.hopital_numerique.model.Department;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;


public class Main {

    public static void main(String[] args) {


//        try (EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit")) {
//            EntityManager em = emf.createEntityManager();
//            em.getTransaction().begin();
//
//            em.getTransaction().commit();
//            em.close();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }


        try (EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit")) {
            EntityManager em = emf.createEntityManager();
            DepartmentDao departmentDao = new DepartmentDao();
            Department department = new Department();
//            department.setName("Orthopedics");
//            departmentDao.save(department);
            System.out.println(departmentDao.findAll());

            em.getTransaction().begin();
            em.getTransaction().commit();
            em.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}