#!/usr/bin/python

from httplib import *
import sys
import json

HOST = 'kangaroo:3000'

class GaggleClient:
    def __init__(self, host):
        self.conn = HTTPConnection(host)

    def close(self):
        self.conn.close()

    def get_document(self, docId):
        self.conn.request('GET', '/documents/%s' % docId)
        return self.conn.getresponse().read()

    def list_documents(self, datatype = None):
        body = None
        if datatype != None:
            body = '{"type":"%s"}' % datatype
        self.conn.request('GET', '/documents', body)
        return self.conn.getresponse().read()

    def add_json(self, jsonstr, projectId = None):
        uri = '/documents'
        if projectId != None:
            uri = '/projects/%s/documents' % projectId
        self.conn.request('POST', uri, jsonstr)
        self.conn.getresponse()

    def update_json(self, docId, jsonstr):
        self.conn.request('PUT', '/documents/%s' % docId, jsonstr)
        self.conn.getresponse()

    def delete_json(self, docId):
        self.conn.request('DELETE', '/documents/%s' % docId)
        self.conn.getresponse()

    def list_projects(self):
        self.conn.request('GET', '/projects')
        return self.conn.getresponse().read()

    def list_project(self, projectId):
        self.conn.request('GET', '/projects/%s' % projectId)
        return self.conn.getresponse().read()

    def add_to_project(self, projectId, docId):
        self.conn.request('PUT', '/projects/%s/documents/%s' % (projectId, docId))
        self.conn.getresponse()

    def remove_from_project(self, projectId, docId):
        self.conn.request('DELETE', '/projects/%s/documents/%s' % (projectId, docId))
        self.conn.getresponse()

def print_document(doc):
    result = "id = '%s'" % doc['_id']
    if doc.has_key('type'):
        result += ", type = '%s'" % doc['type']
    else:
        result += ", type = (undefined)"

    if doc.has_key('name'):
        result += ", name = '%s'" % doc['name']
    else:
        result += ", name = (undefined)"
    print result

def print_documents(jsonstr):
    result = json.loads(jsonstr)
    for doc in result:
        print_document(doc)

def list_with_type(client):
    print "Please enter the data type to list: ",
    data_type = sys.stdin.readline().strip()
    print_documents(client.list_documents(data_type))

def delete_document(client):
    print "Please enter the id of the document to delete: ",
    doc_id = sys.stdin.readline().strip()
    client.delete_json(doc_id)

def main_menu(client):
    doquit = False
    input_str = ""
    print "Main Menu"
    print "Options:"
    print "  (1) List all documents"
    print "  (2) List all documents of a given type"
    print "  (3) Delete a document"
    print "  (4) List projects"
    print "  (5) Quit"
    print "> ",

    try:
        input_str = sys.stdin.readline().strip()
        option = int(input_str)
        print "You entered: %d" % option
        if option == 1:
            print_documents(client.list_documents())
        elif option == 2:
            list_with_type(client)
        elif option == 3:
            delete_document(client)
        elif option == 4:
            print client.list_projects()
        elif option == 5:
            print "So long and thanks for all the fish."
            doquit = True
    except:
        print "unexpected: ", sys.exc_info()
        print "Unsupported option '%s'." % input_str
    if not doquit:
        main_menu(client)

client = GaggleClient(HOST)
print "Gaggle Python Client"
main_menu(client)
client.close()

