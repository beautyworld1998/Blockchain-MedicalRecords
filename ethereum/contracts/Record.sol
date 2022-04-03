pragma solidity ^0.4.17;

contract Record {
    
    struct Patients{
        string ic;
        string name;
        string phone;
        string gender;
        string dob;
        string bloodgroup;
        string allergies;
        address addr;
    }

    struct Doctors{
        string ic;
        string name;
        string phone;
        string gender;
        string dob;
        string qualification;
        string major;
        address addr;
    }

    struct Appointments{
        address doctoraddr;
        address patientaddr;
        string date;
        string time;
        string prescription;
        string description;
        string diagnosis;
        string status;
    }
    
    address public owner;
    address[] public patientList;
    address[] public doctorList;

    mapping(address => Patients) patients;
    mapping(address => Doctors) doctors;
    mapping(address => Appointments) appointments;

    mapping(address=>mapping(address=>bool)) isApproved;
    mapping(address => bool) isPatient;
    mapping(address => bool) isDoctor;

    uint256 public patientCount = 0;
    uint256 public doctorCount = 0;
    uint256 public appointmentCount = 0;
    
    function Record() public {
        owner = msg.sender;
    }
    
    //Retrieve patient details from user sign up page and store the details into the blockchain
    function setDetails(string _ic, string _name, string _phone, string _gender, string _dob, string _bloodgroup, string _allergies) public {
        require(!isPatient[msg.sender]);
        var p = patients[msg.sender];
        
        p.ic = _ic;
        p.name = _name;
        p.phone = _phone;
        p.gender = _gender;
        p.dob = _dob;
        p.bloodgroup = _bloodgroup;
        p.allergies = _allergies;
        p.addr = msg.sender;
        
        patientList.push(msg.sender);
        isPatient[msg.sender] = true;
        isApproved[msg.sender][msg.sender] = true;
        patientCount++;
    }
    
    //Allows user to edit their existing record
    function editDetails(string _ic, string _name, string _phone, string _gender, string _dob, string _bloodgroup, string _allergies) public {
        require(isPatient[msg.sender]);
        var p = patients[msg.sender];
        
        p.ic = _ic;
        p.name = _name;
        p.phone = _phone;
        p.gender = _gender;
        p.dob = _dob;
        p.bloodgroup = _bloodgroup;
        p.allergies = _allergies;
        p.addr = msg.sender;
    }
    
    //Owner of the record must give permission to doctor only they are allowed to view records
    function givePermission(address _address) public returns(bool success) {
        isApproved[msg.sender][_address] = true;
        return true;
    }

    //Retrieve a list of all patients address
    function getPatients() public view returns(address[]) {
        return patientList;
    }

    //Retrieve a list of all doctors address
    function getDoctors() public view returns(address[]) {
        return doctorList;
    }
    
    //Search patient details by entering a patient address (Only record owner or doctor with permission will be allowed to access)
    function searchPatient(address _address) public view returns(string, string, string, string, string, string, string) {
        require(isApproved[_address][msg.sender]);
        
        var p = patients[_address];
        
        return (p.ic, p.name, p.phone, p.gender, p.dob, p.bloodgroup, p.allergies);
    }

    //Search appointment details by entering a patient address
    function searchAppointment(address _address) public view returns(address, string, string, string, string, string, string) {
        var a = appointments[_address];

        return (a.doctoraddr, a.date, a.time, a.diagnosis, a.prescription, a.description, a.status);
    }

    //Retrieve patient details from doctor registration page and store the details into the blockchain
    function setDoctor(string _ic, string _name, string _phone, string _gender, string _dob, string _qualification, string _major) public {
        require(!isDoctor[msg.sender]);
        var d = doctors[msg.sender];
        
        d.ic = _ic;
        d.name = _name;
        d.phone = _phone;
        d.gender = _gender;
        d.dob = _dob;
        d.qualification = _qualification;
        d.major = _major;
        d.addr = msg.sender;
        
        doctorList.push(msg.sender);
        isDoctor[msg.sender] = true;
        doctorCount++;
    }

    //Retrieve appointment details from appointment page and store the details into the blockchain
    function setAppointment(address _addr, string _date, string _time, string _diagnosis, string _prescription, string _description, string _status) public {
        require(isDoctor[msg.sender]);
        var a = appointments[_addr];
        
        a.doctoraddr = msg.sender;
        a.patientaddr = _addr;
        a.date = _date;
        a.time = _time;
        a.diagnosis = _diagnosis;
        a.prescription = _prescription; 
        a.description = _description;
        a.status = _status;

        appointmentCount++;
    }
    
    //Retrieve appointment details from appointment page and store the details into the blockchain
    function updateAppointment(address _addr, string _date, string _time, string _diagnosis, string _prescription, string _description, string _status) public {
        require(isDoctor[msg.sender]);
        var a = appointments[msg.sender];
        
        a.doctoraddr = msg.sender;
        a.patientaddr = _addr;
        a.date = _date;
        a.time = _time;
        a.diagnosis = _diagnosis;
        a.prescription = _prescription; 
        a.description = _description;
        a.status = _status;
    }

    //Retrieve patient count
    function getPatientCount() public view returns(uint256) {
        return patientCount;
    }

    //Retrieve doctor count
    function getDoctorCount() public view returns(uint256) {
        return doctorCount;
    }

    //Retrieve appointment count
    function getAppointmentCount() public view returns(uint256) {
        return appointmentCount;
    }
}