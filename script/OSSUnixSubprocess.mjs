import cprocess from 'child_process';
import stream from 'memory-streams';

export class OSSUnixSubprocess {
  constructor() {
    this._command = "";
    this._app = "";
    this._arguments = [];
    this._stdoutStream = null;
    this._stderrStream = null;
    this._exitStatus = 0;
    this.errorMessage = "";
  }
  shellCommand_(cmd) {
    this._command = cmd;
  }
  command_(cmd) {
    this._app = cmd;
  }
  arguments_(list) {
    this._arguments = list;
  }
  redirectStdout() {
  }
  redirectStderr() {
  }
  runAndWait() {
    var cmd = this._command || (this._app + ' ' + this._arguments.join(' '));
    try {
      var stdout = cprocess.execSync(cmd).toString();
      this._stdoutStream = new stream.ReadableStream(stdout);
      this._stdoutStream.setEncoding('utf8');
    } catch (error) {
      this._exitStatus = error.status;
      this.errorMessage = error.message;
      this._stderrStream = new stream.ReadableStream(error.stderr);
      this._stderrStream.setEncoding('utf8');
      this._stdoutStream = new stream.ReadableStream(error.stdout);
      this._stdoutStream.setEncoding('utf8');
    }
  }
  isSuccess() {
    return this._exitStatus === 0;
  }
  stdoutStream() {
    return this._stdoutStream;
  }
  stderrStream() {
    return this._stderrStream;
  }
  closeAndCleanStreams() {
  }

  workingDirectory_(newDir) {
  }
}
