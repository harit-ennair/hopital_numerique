package com.example.hopital_numerique;

import com.example.hopital_numerique.dao.*;
import com.example.hopital_numerique.model.*;
import com.example.hopital_numerique.services.PatientServ;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.time.LocalDate;
import java.time.LocalTime;


public class Main {

    public static void main(String[] args) {


        try (EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit")) {
            EntityManager em = emf.createEntityManager();
            em.getTransaction().begin();

            em.getTransaction().commit();
            em.close();
        } catch (Exception e) {
            e.printStackTrace();
        }


        try (EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit")) {
            EntityManager em = emf.createEntityManager();
            DepartmentDao departmentDao = new DepartmentDao();
            Department department = new Department();
//            department.setId(5);
            department.setName("Hematology");
            departmentDao.save(department);

            RoomDao roomDao = new RoomDao();
            Room room = new Room();
//            room.setId(5);
            room.setName("Room 103");
            room.setCapacity(8);
            roomDao.save(room);

            DoctorDao doctorDao = new DoctorDao();
            Doctor doctor = new Doctor();
//            doctor.setId(5);
            doctor.setFirstName("Dr. ayoub");
            doctor.setLastName("Johnson");
            doctor.setEmail("doc@gmail.com");
            doctor.setSpecialty("Cardiology");
            doctor.setPassword("123456");
            doctor.setRole("DOCTOR");
            doctor.setDepartment(department);
            doctorDao.save(doctor);
//            System.out.println(departmentDao.findAll());


            PatientDao patientDao = new PatientDao();
            Patient pation = new Patient();
//            pation.setId(5);
            pation.setFirstName("mahir");
            pation.setLastName("Johnson");
            pation.setEmail("pat@gmail.com");
            pation.setPassword("123456");
            pation.setRole("PATIENT");
            pation.setWeight(185);
            pation.setHeight(90);
            patientDao.save(pation);

            ConsulltationDao consulltationDao = new ConsulltationDao();
            Consultation consultation = new Consultation();
            LocalDate date = LocalDate.of(2024, 6, 20);
            consultation.setDate(date);
            LocalTime hour = LocalTime.of(10, 0);
            consultation.setHour(hour);
            consultation.setDoctor(doctor);
            consultation.setPatient(pation);
            consultation.setRoom(room);
//            consulltationDao.save(consultation);
//            System.out.println(consulltationDao.findAll());


            PatientServ patientServ = new PatientServ(consulltationDao , doctorDao , roomDao);
            patientServ.bookAppointment(pation, doctor, consultation, room, date, hour);






            em.getTransaction().begin();
            em.getTransaction().commit();
            em.close();

        } catch (Exception e) {
            e.printStackTrace();
        }


    }
}