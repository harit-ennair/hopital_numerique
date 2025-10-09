package com.example.hopital_numerique.dao;

import com.example.hopital_numerique.dao.daoInterfaces.Ipatient;
import com.example.hopital_numerique.model.Patient;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.List;

public class patientDao implements Ipatient {
    @Override
    public void save(Patient patient) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(patient);
        em.getTransaction().commit();
        em.close();
        emf.close();

    }

    @Override
    public void update(Patient patient) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(patient);
        em.getTransaction().commit();
        em.close();
        emf.close();

    }

    @Override
    public void delete(int patientId) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Patient patient = em.find(Patient.class, patientId);
        if (patient != null) {
            em.getTransaction().begin();
            em.remove(patient);
            em.getTransaction().commit();
        }
        em.close();
        emf.close();

    }

    @Override
    public Patient findById(int patientId) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Patient patient = em.find(Patient.class, patientId);
        em.close();
        emf.close();
        return patient;
    }

    @Override
    public Patient findByEmail(String email) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Patient patient = em.createQuery("SELECT p FROM Patient p WHERE p.email = :email", Patient.class)
                .setParameter("email", email)
                .getSingleResult();
        em.close();
        emf.close();
        return patient;
    }

    @Override
    public List<Patient> findAll() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Patient> patients = em.createQuery("SELECT p FROM Patient p", Patient.class).getResultList();
        em.close();
        emf.close();
        return patients;
    }

    @Override
    public List<Patient> findByFirstName(String firstName) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Patient> patients = em.createQuery("SELECT p FROM Patient p WHERE p.firstName = :firstName", Patient.class)
                .setParameter("firstName", firstName)
                .getResultList();
        em.close();
        emf.close();
        return patients;
    }

    @Override
    public List<Patient> findByLastName(String lastName) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Patient> patients = em.createQuery("SELECT p FROM Patient p WHERE p.lastName = :lastName", Patient.class)
                .setParameter("lastName", lastName)
                .getResultList();
        em.close();
        emf.close();
        return patients;
    }
}
