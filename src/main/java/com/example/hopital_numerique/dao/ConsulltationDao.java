package com.example.hopital_numerique.dao;

import com.example.hopital_numerique.dao.daoInterfaces.Iconsultation;
import com.example.hopital_numerique.model.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public class ConsulltationDao implements Iconsultation {

    @Override
    public void save(Consultation consultation) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(consultation);
        em.getTransaction().commit();
        em.close();
        emf.close();

    }

    @Override
    public void update(Consultation consultation) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(consultation);
        em.getTransaction().commit();
        em.close();
        emf.close();

    }

    @Override
    public void delete(int consultationId) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Consultation consultation = em.find(Consultation.class, consultationId);
        if (consultation != null) {
            em.remove(consultation);
        }
        em.getTransaction().commit();
        em.close();
        emf.close();

    }

    @Override
    public Consultation findById(int consultationId) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Consultation consultation = em.find(Consultation.class, consultationId);
        em.close();
        emf.close();
        return consultation;
    }

    @Override
    public List<Consultation> findAll() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Consultation> consultations = em.createQuery("SELECT c FROM Consultation c", Consultation.class).getResultList();
        em.close();
        emf.close();
        return consultations;
    }

    @Override
    public List<Consultation> findByPatient(Patient patient) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Consultation> consultations = em.createQuery(
            "SELECT c FROM Consultation c WHERE c.patient = :patient", Consultation.class)
            .setParameter("patient", patient)
            .getResultList();
        em.close();
        emf.close();
        return consultations;
    }

    @Override
    public List<Consultation> findByDoctor(Doctor doctor) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Consultation> consultations = em.createQuery(
            "SELECT c FROM Consultation c WHERE c.doctor = :doctor", Consultation.class)
            .setParameter("doctor", doctor)
            .getResultList();
        em.close();
        emf.close();
        return consultations;
    }

    @Override
    public List<Consultation> findByRoom(Room room) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Consultation> consultations = em.createQuery(
            "SELECT c FROM Consultation c WHERE c.room = :room", Consultation.class)
            .setParameter("room", room)
            .getResultList();
        em.close();
        emf.close();
        return consultations;
    }

    @Override
    public List<Consultation> findByDate(LocalDate date) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Consultation> consultations = em.createQuery(
            "SELECT c FROM Consultation c WHERE c.date = :date", Consultation.class)
            .setParameter("date", date)
            .getResultList();
        em.close();
        emf.close();
        return consultations;
    }

    @Override
    public List<Consultation> findByStatus(Status status) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Consultation> consultations = em.createQuery(
            "SELECT c FROM Consultation c WHERE c.statusByName = :status", Consultation.class)
            .setParameter("status", status)
            .getResultList();
        em.close();
        emf.close();
        return consultations;
    }

    @Override
    public boolean isRoomAvailable(Room room, LocalDate date, LocalTime time) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Long count = em.createQuery(
            "SELECT COUNT(c) FROM Consultation c WHERE c.room = :room AND c.date = :date AND c.hour = :time AND c.statusByName IN ('RESERVED', 'VALIDATED')", Long.class)
            .setParameter("room", room)
            .setParameter("date", date)
            .setParameter("time", time)
            .getSingleResult();
        em.close();
        emf.close();
        return count == 0;
    }

    @Override
    public boolean isDoctorAvailable(Doctor doctor, LocalDate date, LocalTime time) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Long count = em.createQuery(
            "SELECT COUNT(c) FROM Consultation c WHERE c.doctor = :doctor AND c.date = :date AND c.hour = :time AND c.statusByName IN ('RESERVED', 'VALIDATED')", Long.class)
            .setParameter("doctor", doctor)
            .setParameter("date", date)
            .setParameter("time", time)
            .getSingleResult();
        em.close();
        emf.close();
        return count == 0;
    }
}
