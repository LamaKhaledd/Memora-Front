
class Config {
  static const apiUrl = '192.168.1.21:8000';

//static const apiUrl = 'localhost:8000';

  static const String loginUrl = '/api/login';
  static const String signupUrl = '/api/register';
  static const String jobs = '/api/jobs';
  static const String jobadd = '/api/jobs/';


    static const String task = '/api/Task/';
  static const String pro = '/api/project';
  static const String search = '/api/jobs/search';
  static const String job = '/api/jobs';
  static const String profileUrl = '/api/users/';
  static const String getprofileUrl = '/api/users/';
  static const String getMembersByJobId = '/api/jobs/members';

  static const String bookmarkUrl = '/api/bookmarks';
  static const String chatsUrl = '/api/chats';
  static const String messagingUrl = '/api/messages';
  static const String quiz = '/api/Quiz/';
  static const String Get_quiz = '/api/Quiz/job';
  static const String FormJobs = 'api/Form';
  static const String mobile = '/api/jobs/searc/mobile';
  static const String Frontend = '/api/jobs/searc/Frontend';
  static const String Backend = '/api/jobs/searc/Backend';
  static const String Ai = '/api/jobs/searc/Ai';
  static const String GetFormJobs = 'api/Form/Get';
  //static const String AllForm = 'api/Form/GetAll';

  static const String AllForm = 'api/Form/GetAll?adminId=';

  static const String GetTaskid = '/api/Task/Getbyid';

  static const String GetAllTask = '/api/Task?jobid=';

static const AddTask = 'api/Task';

  static const String Jobforcompany = 'api/jobs/admin';

  static const String getjobformember = 'api/jobs/member';
  static const String delete = 'api/jobs/';
}
