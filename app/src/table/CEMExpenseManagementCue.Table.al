table 6086327 "CEM Expense Management Cue"
{
    Caption = 'Cue for Expense Management';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Expenses - Open"; Integer)
        {
            CalcFormula = count("CEM Expense" where(Status = const(Open),
                                                     "Settlement No." = filter(''),
                                                     "Continia User ID" = field("Continia User Filter")));
            Caption = 'Expenses - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Expenses - Pending"; Integer)
        {
            CalcFormula = count("CEM Expense" where(Status = filter("Pending Expense User" | "Pending Approval"),
                                                     "Settlement No." = filter(''),
                                                     "Continia User ID" = field("Continia User Filter")));
            Caption = 'Expenses - Pending';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Expenses - Ready for Posting"; Integer)
        {
            CalcFormula = count("CEM Expense" where(Status = filter(Released),
                                                     Posted = const(false),
                                                     "Settlement No." = filter(''),
                                                     "Continia User ID" = field("Continia User Filter")));
            Caption = 'Expenses - Ready for Posting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Expense Inbox - Errors"; Integer)
        {
            CalcFormula = count("CEM Expense Inbox" where(Status = filter(Pending | Error),
                                                           "Continia User ID" = field("Continia User Filter")));
            Caption = 'Expense Inbox - Errors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Bank Trans. - Unmatched"; Integer)
        {
            CalcFormula = count("CEM Bank Transaction" where("Matched to Expense" = const(false),
                                                              "Continia User ID" = field("Continia User Filter"),
                                                              "Bank Statement Transaction" = const(false),
                                                              "Exclude Entry" = const(false)));
            Caption = 'Bank Trans. - Unmatched';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Bank Trans. Inbox - Errors"; Integer)
        {
            CalcFormula = count("CEM Bank Transaction Inbox" where(Status = filter(Pending | Error),
                                                                    "Exclude Entry" = const(false),
                                                                    "Continia User ID" = field("Continia User Filter")));
            Caption = 'Bank Transaction Inbox - Errors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Mileage - Open"; Integer)
        {
            CalcFormula = count("CEM Mileage" where(Status = const(Open),
                                                     "Settlement No." = filter(''),
                                                     "Continia User ID" = field("Continia User Filter")));
            Caption = 'Mileage - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Mileage - Pending"; Integer)
        {
            CalcFormula = count("CEM Mileage" where(Status = filter("Pending Expense User" | "Pending Approval"),
                                                     "Settlement No." = filter(''),
                                                     "Continia User ID" = field("Continia User Filter")));
            Caption = 'Mileage - Pending';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Mileage - Ready for Posting"; Integer)
        {
            CalcFormula = count("CEM Mileage" where(Status = filter(Released),
                                                     Posted = const(false),
                                                     "Settlement No." = filter(''),
                                                     "Continia User ID" = field("Continia User Filter")));
            Caption = 'Mileage - Ready for Posting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Mileage Inbox - Errors"; Integer)
        {
            CalcFormula = count("CEM Mileage Inbox" where(Status = filter(Pending | Error),
                                                           "Continia User ID" = field("Continia User Filter")));
            Caption = 'Mileage Inbox - Errors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Settlement - Open"; Integer)
        {
            CalcFormula = count("CEM Expense Header" where(Status = const(Open),
                                                            "Document Type" = const(Settlement),
                                                            "Continia User ID" = field("Continia User Filter")));
            Caption = 'Settlement - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Settlement - Pending"; Integer)
        {
            CalcFormula = count("CEM Expense Header" where(Status = filter("Pending Expense User" | "Pending Approval"),
                                                            "Document Type" = const(Settlement),
                                                            "Continia User ID" = field("Continia User Filter")));
            Caption = 'Settlement - Pending';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Settlement - Ready for Posting"; Integer)
        {
            CalcFormula = count("CEM Expense Header" where(Status = filter(Released),
                                                            Posted = const(false),
                                                            "Document Type" = const(Settlement),
                                                            "Continia User ID" = field("Continia User Filter")));
            Caption = 'Settlement - Ready for Posting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Settlement Inbox - Errors"; Integer)
        {
            CalcFormula = count("CEM Expense Header Inbox" where(Status = filter(Pending | Error),
                                                                  "Continia User ID" = field("Continia User Filter")));
            Caption = 'Settlement Inbox - Errors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Continia User Filter"; Text[250])
        {
            Caption = 'Continia User Filter';
            FieldClass = FlowFilter;
        }
        field(21; "Per Diem - Open"; Integer)
        {
            CalcFormula = count("CEM Per Diem" where(Status = const(Open),
                                                      "Settlement No." = filter(''),
                                                      "Continia User ID" = field("Continia User Filter")));
            Caption = 'Per Diem - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Per Diem - Pending"; Integer)
        {
            CalcFormula = count("CEM Per Diem" where(Status = filter("Pending Expense User" | "Pending Approval"),
                                                      "Settlement No." = filter(''),
                                                      "Continia User ID" = field("Continia User Filter")));
            Caption = 'Per Diem - Pending';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Per Diem - Ready for Posting"; Integer)
        {
            CalcFormula = count("CEM Per Diem" where(Status = filter(Released),
                                                      Posted = const(false),
                                                      "Settlement No." = filter(''),
                                                      "Continia User ID" = field("Continia User Filter")));
            Caption = 'Per Diem - Ready for Posting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Per Diem Inbox - Errors"; Integer)
        {
            CalcFormula = count("CEM Per Diem Inbox" where(Status = filter(Pending | Error),
                                                            "Continia User ID" = field("Continia User Filter")));
            Caption = 'Per Diem Inbox - Errors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Notification Outbox - Pending"; Integer)
        {
            CalcFormula = count("CEM Release Notification Entry" where(Status = const(Pending)));
            Caption = 'Notification Outbox - Pending';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Notification Outbox - Errors"; Integer)
        {
            CalcFormula = count("CEM Release Notification Entry" where(Status = const(Error)));
            Caption = 'Notification Outbox - Errors';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

