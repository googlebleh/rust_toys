use std::env;
use std::fs;
use std::io::Write;

fn main()
{
    let argv: Vec<String> = env::args().collect();

    let log_fpath = "/tmp/arguments.log";
    let mut log_f = fs::OpenOptions::new()
        .create(true)
        .write(true)
        .append(true)
        .open(log_fpath)
        .unwrap();

    write!(log_f, "{:?}\n", argv)
        .expect("error: write!");
}
