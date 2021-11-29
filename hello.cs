using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.ExceptionServices;
using System.Collections; using System.Linq;

namespace RawrrEmbed
{
  class RawRr
  {
    string errormsg = "";
    string filesize = "";

    String filename = null;

    RawRr ()
    {
      this.filename = @"/tmp/sample.raw";
    }

    void setRawFile(string f){
      this.filename = f;
    }

    string[]get_info ()
    {
      String[]rv = new String[7];
      Process currentProcess = Process.GetCurrentProcess ();
      rv[0] = System.Reflection.Assembly.GetExecutingAssembly ().CodeBase;
      rv[1] = "file size of " + this.filename + " is " + this.filesize + " Bytes.";//String.Join("; ", Directory.GetFiles("."));
	/*
	System.Reflection.Assembly.
	GetAssembly (typeof (IRawDataPlus)).Location;
	*/
      rv[2] = currentProcess.ToString ();
      rv[3] = "currentProcess.Id:\t" + currentProcess.Id.ToString ();
      rv[4] =
          "PrivateMemorySize64 (KB):\t" +
          (currentProcess.PrivateMemorySize64 / 1024).ToString ();
      rv[5] = "Error message:\t" + this.errormsg;
      rv[6] = "raw file name:\t" + this.filename;
      /*
         try{
         long length = new System.IO.FileInfo(this.filename).Length;
         rv[7] = "raw file size:\t" + length.ToString();
         }catch (Exception ex)
         {
         rv[7] = "raw file size:\tcan not be determined catch Exception. " + ex.Message;
         }
       */
      //this.rawFile.SelectInstrument (Device.MS, 1);

      return (rv);
    }

    void openFile ()
    {
      try
      {
          File.Exists (this.filename);
          FileInfo fi = new FileInfo(this.filename);
          this.filesize = fi.Length.ToString();
      }
      catch (Exception ex)
      {
          this.errormsg =
              "raw file size:\tcan not be determined catch Exception. \n>>" +
              ex.Message + "<<\n"+ 
              ex.StackTrace + "<<\n";
      }
    }

    private static void Main (string[]args)
    {
      string codeBase = System.Reflection.Assembly.GetExecutingAssembly().CodeBase;
      //string fullPath = System.Reflection.Assembly.GetAssembly(typeof(IRawDataPlus)).Location;
      Console.WriteLine(codeBase);

      //Console.WriteLine(fullPath);
      //Console.WriteLine(System.Reflection.Assembly.GetExecutingAssembly().Location);

      RawRr R = new RawRr();
      R.setRawFile("hello.h");
      foreach (var msg in R.get_info()){
         Console.WriteLine(msg);
      }
      R.openFile();

      foreach (var msg in R.get_info()){
         Console.WriteLine(msg);
      }
      //          }
      //          Console.WriteLine(R.get_Revision());
    }
  }
}
