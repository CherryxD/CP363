import mysql.connector
import os
from dotenv import load_dotenv
import tkinter as tk
from tkinter import scrolledtext, messagebox

# Load sensitive variables from .env
load_dotenv()
db_pass = os.getenv('SQL_PASS')
db_name = os.getenv('DB_NAME')

# DB Functions
def connectdb():
    try:
        connection = mysql.connector.connect(user='root', password=db_pass, host='127.0.0.1', database=db_name)
        if connection.is_connected():
            return connection
    except:
        log_output("❌ Error connecting to the database.")
        return None

def exec_from_file(filename, c):
    try:
        with open(filename, mode='r', encoding='utf-8') as file:
            sqlFile = file.read()
    except Exception as e:
        log_output(f"❌ Error reading {filename}: {e}")
        return

    commands = sqlFile.split(';')
    for command in commands:
        command = command.strip()
        if not command:
            continue
        try:
            c.execute(command)
            log_output(f"✅ Executed: {command}")
        except Exception as e:
            log_output(f"⚠️ Skipped: {command} due to {e}")

def run_script(filename, action_desc):
    con = connectdb()
    if con:
        try:
            c = con.cursor()
            exec_from_file(filename, c)
            con.commit()
            log_output(f"✅ {action_desc} successful.\n")
        except Exception as e:
            log_output(f"❌ {action_desc} failed: {e}")
        finally:
            con.close()

def drop_tables():
    run_script('drop_tables.sql', "Drop tables")

def create_tables():
    run_script('create_tables.sql', "Create tables")

def populate_tables():
    run_script('populate_tables.sql', "Populate tables")

def execute_query():
    query = query_input.get("1.0", tk.END).strip()
    if not query:
        messagebox.showwarning("Input Error", "Query cannot be empty.")
        return
    connection = connectdb()
    if connection:
        try:
            cursor = connection.cursor(buffered=True)
            cursor.execute(query)
            connection.commit()
            result_output = ""
            if cursor.with_rows:
                for row in cursor:
                    result_output += f"{row}\n"
            else:
                result_output = "✅ Query executed (no return data)."
            log_output(result_output)
        except Exception as e:
            log_output(f"❌ Error with query: {e}")
        finally:
            cursor.close()
            connection.close()

# GUI Setup
root = tk.Tk()
root.title("MySQL Database Manager")

# Buttons
btn_frame = tk.Frame(root)
btn_frame.pack(pady=10)

tk.Button(btn_frame, text="Drop Tables", width=15, command=drop_tables).grid(row=0, column=0, padx=5)
tk.Button(btn_frame, text="Create Tables", width=15, command=create_tables).grid(row=0, column=1, padx=5)
tk.Button(btn_frame, text="Populate Tables", width=15, command=populate_tables).grid(row=0, column=2, padx=5)
tk.Button(btn_frame, text="Execute Query", width=15, command=execute_query).grid(row=0, column=3, padx=5)

# Query input
tk.Label(root, text="Enter SQL Query:").pack()
query_input = tk.Text(root, height=5, width=80)
query_input.pack(padx=10)

# Output box
tk.Label(root, text="Output:").pack()
output_box = scrolledtext.ScrolledText(root, height=15, width=100, wrap=tk.WORD)
output_box.pack(padx=10, pady=10)

def log_output(message):
    output_box.insert(tk.END, f"{message}\n")
    output_box.see(tk.END)

# Run the GUI loop
root.mainloop()
