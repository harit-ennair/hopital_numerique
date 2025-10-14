package com.example.hopital_numerique.services;

import com.example.hopital_numerique.dao.DepartmentDao;
import com.example.hopital_numerique.dao.daoInterfaces.Iconsultation;
import com.example.hopital_numerique.dao.daoInterfaces.Idepartment;
import com.example.hopital_numerique.dao.daoInterfaces.Idoctor;
import com.example.hopital_numerique.dao.daoInterfaces.Iroom;
import com.example.hopital_numerique.model.*;
import com.example.hopital_numerique.services.serviceIntefaces.ISadmen;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public class AdmenServ implements ISadmen {

    Idepartment departmentDao;
    Idoctor doctorDao;
    Iroom roomDao;
    Iconsultation consultationDao;

    public AdmenServ(Idepartment departmentDao , Idoctor doctorDao , Iroom roomDao , Iconsultation consultationDao) {
        this.roomDao = roomDao;
        this.departmentDao = departmentDao;
        this.doctorDao = doctorDao;
        this.consultationDao = consultationDao;
    }

    @Override
    public Department createDepartment(Department department) {
        if(department.getName() == null || department.getName().isEmpty()) {
            throw new IllegalArgumentException("Department name cannot be null or empty");
        }
        departmentDao.save(department);
        return department;
    }

    @Override
    public void updateDepartment(Department department) {
        if(department.getId() <= 0 || department.getName().isEmpty()) {
            throw new IllegalArgumentException("Department ID cannot be null");
        }
        departmentDao.update(department);

    }

    @Override
    public void deleteDepartment(Department department) {
        if(department.getId() <= 0) {
            throw new IllegalArgumentException("Department ID cannot be null");
        }
        departmentDao.delete(department.getId());

    }

    @Override
    public List<Department> getAllDepartments() {
        return departmentDao.findAll();
    }

    @Override
    public Department getDepartmentById(Department department) {
        if(department.getId() <= 0) {
            throw new IllegalArgumentException("Department ID cannot be null");
        }
        return departmentDao.findById(department.getId());
    }

    @Override
    public Doctor createDoctor(Doctor doctor) {
        if(doctor.getFirstName() == null || doctor.getFirstName().isEmpty() ||
           doctor.getLastName() == null || doctor.getLastName().isEmpty() ||
           doctor.getEmail() == null || doctor.getEmail().isEmpty() ||
           doctor.getSpecialty() == null || doctor.getSpecialty().isEmpty()) {
            throw new IllegalArgumentException("Doctor fields cannot be null or empty");
        }
        doctorDao.save(doctor);
        return doctor;
    }

    @Override
    public void updateDoctor(Doctor doctor) {
        if(doctor.getId() <= 0 ||
           doctor.getFirstName() == null || doctor.getFirstName().isEmpty() ||
           doctor.getLastName() == null || doctor.getLastName().isEmpty() ||
           doctor.getEmail() == null || doctor.getEmail().isEmpty() ||
           doctor.getSpecialty() == null || doctor.getSpecialty().isEmpty()) {
            throw new IllegalArgumentException("Doctor fields cannot be null or empty");
        }
        doctorDao.update(doctor);

    }

    @Override
    public void deleteDoctor(Doctor doctor) {
        if(doctor.getId() <= 0) {
            throw new IllegalArgumentException("Doctor ID cannot be null");
        }
        doctorDao.delete(doctor.getId());
    }

    @Override
    public List<Doctor> getAllDoctors() {
        return doctorDao.findAll();
    }

    @Override
    public List<Doctor> getDoctorsByDepartment(Doctor doctor) {
        if(doctor.getDepartment() == null) {
            throw new IllegalArgumentException("Department cannot be null");
        }
        return doctorDao.findByDepartment(doctor.getDepartment());
    }

    @Override
    public Doctor getDoctorById(Doctor doctor) {
        if(doctor.getId() <= 0) {
            throw new IllegalArgumentException("Doctor ID cannot be null");
        }
        return doctorDao.findById(doctor.getId());
    }

    @Override
    public Room createRoom(Room room) {
        if(room.getId() <= 0 || room.getName() == null || room.getName().isEmpty() ||
           room.getCapacity() <= 0) {
            throw new IllegalArgumentException("Room fields cannot be null or empty");
        }
        roomDao.save(room);
        return room;
    }

    @Override
    public void updateRoom(Room room) {
        if(room.getId() <= 0 || room.getName() == null || room.getName().isEmpty() ||
           room.getCapacity() <= 0) {
            throw new IllegalArgumentException("Room fields cannot be null or empty");
        }
        roomDao.update(room);

    }

    @Override
    public void deleteRoom(Room room) {
        if(room.getId() <= 0) {
            throw new IllegalArgumentException("Room ID cannot be null");
        }
        roomDao.delete(room.getId());

    }

    @Override
    public void assignRoomToConsultation(Consultation consultation, Room room) {
        if(consultation.getId() <= 0 || room.getId() <= 0) {
            throw new IllegalArgumentException("Consultation ID and Room ID cannot be null");
        }
        consultation.setRoom(room);

    }
//=======================================================================================================


    @Override
    public List<Room> getAvailableRooms(Room room) {
        if(room.getId() <= 0) {
            throw new IllegalArgumentException("Room ID cannot be null");
        }
        List<Room> allRooms = roomDao.findAll();
        List<Room> occupiedRooms = consultationDao.findAll().stream()
                .filter(c -> c.getRoom() != null &&
                             (c.getStatus() == Status.VALIDATED || c.getStatus() == Status.PENDING))
                .map(Consultation::getRoom)
                .distinct()
                .toList();
        allRooms.removeAll(occupiedRooms);
        return allRooms;
    }
//=======================================================================================================

    @Override
    public List<Room> getAllRooms() {
        return roomDao.findAll();
    }


    @Override
    public List<Consultation> getAllConsultations() {
        return consultationDao.findAll();
    }

    @Override
    public List<Consultation> getConsultationsByDate(LocalDate date) {
        if(date == null) {
            throw new IllegalArgumentException("Date cannot be null");
        }
        return consultationDao.findAll().stream().filter(c ->
                c.getDate().isEqual(date)).toList();
    }

    @Override
    public List<Consultation> getConsultationsByStatus(Status status) {
        if(status == null) {
            throw new IllegalArgumentException("Status cannot be null");
        }
        return consultationDao.findByStatus(status);
    }

    @Override
    public List<Consultation> getConsultationsByDoctor(Doctor doctor) {
        if(doctor == null || doctor.getId() <= 0) {
            throw new IllegalArgumentException("Doctor ID cannot be null");
        }
        return consultationDao.findByDoctor(doctor);
    }

    @Override
    public List<Consultation> getConsultationsByPatient(Patient patient) {
        if(patient == null || patient.getId() <= 0) {
            throw new IllegalArgumentException("Patient ID cannot be null");
        }
        return consultationDao.findByPatient(patient);
    }

    @Override
    public List<Consultation> getConsultationsByDepartment(Department department) {
        if(department == null || department.getId() <= 0) {
            throw new IllegalArgumentException("Department ID cannot be null");
        }
        return consultationDao.findAll().stream().filter(c ->
                c.getDoctor().getDepartment().getId() == department.getId()).toList();
    }

    @Override
    public int getTotalConsultationsCount() {
        return consultationDao.findAll().size();
    }

    @Override
    public int getConsultationsCountByStatus(Status status) {
        if(status == null) {
            throw new IllegalArgumentException("Status cannot be null");
        }
        return consultationDao.findByStatus(status).size();
    }

    @Override
    public int getConsultationsCountByDoctor(Doctor doctor) {
        if(doctor == null || doctor.getId() <= 0) {
            throw new IllegalArgumentException("Doctor ID cannot be null");
        }
        return consultationDao.findByDoctor(doctor).size();
    }


}
