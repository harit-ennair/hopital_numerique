package com.example.hopital_numerique.dao;

import com.example.hopital_numerique.dao.daoInterfaces.Idoctor;
import com.example.hopital_numerique.model.Department;
import com.example.hopital_numerique.model.Doctor;
import com.example.hopital_numerique.model.Patient;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.List;

public class doctorDao implements Idoctor {
    @Override
    public void save(Doctor doctor) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(doctor);
        em.getTransaction().commit();
        em.close();
        emf.close();

    }

    @Override
    public void update(Doctor doctor) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(doctor);
        em.getTransaction().commit();
        em.close();
        emf.close();

    }

    @Override
    public void delete(int doctorId) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Doctor doctor = em.find(Doctor.class, doctorId);
        if (doctor != null) {
            em.getTransaction().begin();
            em.remove(doctor);
            em.getTransaction().commit();
        }
        em.close();
        emf.close();

    }

    @Override
    public Doctor findById(int doctorId) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Doctor doctor = em.find(Doctor.class, doctorId);
        em.close();
        emf.close();
        return doctor;
    }

    @Override
    public Doctor findByEmail(String email) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Doctor doctor = em.createQuery("SELECT d FROM Doctor d WHERE d.email = :email", Doctor.class)
                .setParameter("email", email)
                .getSingleResult();
        em.close();
        emf.close();
        return doctor;
    }

    @Override
    public List<Doctor> findAll() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Doctor> doctors = em.createQuery("SELECT d FROM Doctor d", Doctor.class).getResultList();
        em.close();
        emf.close();
        return doctors;
    }

    @Override
    public List<Doctor> findBySpecialty(String specialty) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Doctor> doctors = em.createQuery("SELECT d FROM Doctor d WHERE d.specialty = :specialty", Doctor.class)
                .setParameter("specialty", specialty)
                .getResultList();
        em.close();
        emf.close();
        return doctors;
    }

    @Override
    public List<Doctor> findByDepartment(Department department) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Doctor> doctors = em.createQuery("SELECT d FROM Doctor d WHERE d.department = :department", Doctor.class)
                .setParameter("department", department)
                .getResultList();
        em.close();
        emf.close();
        return doctors;
    }

    @Override
    public List<Doctor> findByFirstName(String firstName) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Doctor> doctors = em.createQuery("SELECT d FROM Doctor d WHERE d.firstName = :firstName", Doctor.class)
                .setParameter("firstName", firstName)
                .getResultList();
        em.close();
        emf.close();
        return doctors;
    }

    @Override
    public List<Doctor> findByLastName(String lastName) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Doctor> doctors = em.createQuery("SELECT d FROM Doctor d WHERE d.lastName = :lastName", Doctor.class)
                .setParameter("lastName", lastName)
                .getResultList();
        em.close();
        emf.close();
        return doctors;
    }
}
