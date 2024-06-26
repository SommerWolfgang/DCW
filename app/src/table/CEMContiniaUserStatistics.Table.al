table 6086354 "CEM Continia User Statistics"
{
    Caption = 'Continia User EM Statistics';

    fields
    {
        field(1; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User";
        }
        field(2; "Expenses Pending Users"; Integer)
        {
            CalcFormula = count("CEM Expense" where("Continia User ID" = field("Continia User ID"),
                                                     Status = filter("Pending Expense User"),
                                                     Posted = const(false),
                                                     "Settlement No." = filter('')));
            Caption = 'Expenses Pending Users';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Exp. Amt. Pending Users (LCY)"; Decimal)
        {
            CalcFormula = sum("CEM Expense"."Amount (LCY)" where(Status = filter("Pending Expense User"),
                                                                  "Continia User ID" = field("Continia User ID"),
                                                                  Posted = const(false),
                                                                  "Settlement No." = filter('')));
            Caption = 'Expense Amount Pending Users (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Exp.Amt. Pending App (LCY)"; Decimal)
        {
            CalcFormula = sum("CEM Expense"."Amount (LCY)" where("Continia User ID" = field("Continia User ID"),
                                                                  Status = filter("Pending Approval"),
                                                                  Posted = const(false),
                                                                  "Settlement No." = filter('')));
            Caption = 'Expense Amount Pending Approval (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Exp. Amt. Ready To Post (LCY)"; Decimal)
        {
            CalcFormula = sum("CEM Expense"."Amount (LCY)" where(Status = filter(Released),
                                                                  "Continia User ID" = field("Continia User ID"),
                                                                  Posted = const(false),
                                                                  "Settlement No." = filter('')));
            Caption = 'Expense Amount Ready To Post (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Open Expenses"; Integer)
        {
            CalcFormula = count("CEM Expense" where("Continia User ID" = field("Continia User ID"),
                                                     Status = const(Open),
                                                     "Settlement No." = filter(''),
                                                     Posted = const(false)));
            Caption = 'Open Expenses';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Expenses Ready for Posting"; Integer)
        {
            CalcFormula = count("CEM Expense" where("Continia User ID" = field("Continia User ID"),
                                                     Status = filter(Released),
                                                     Posted = const(false),
                                                     "Settlement No." = filter('')));
            Caption = 'Expenses Ready for Posting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Open Mileage"; Integer)
        {
            CalcFormula = count("CEM Mileage" where("Continia User ID" = field("Continia User ID"),
                                                     Status = const(Open),
                                                     "Settlement No." = filter(''),
                                                     Posted = const(false)));
            Caption = 'Open Mileage';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Mileage Pending Users"; Integer)
        {
            CalcFormula = count("CEM Mileage" where("Continia User ID" = field("Continia User ID"),
                                                     Status = filter("Pending Expense User"),
                                                     "Settlement No." = filter(''),
                                                     Posted = const(false)));
            Caption = 'Mileage Pending Users';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Mileage Ready for Posting"; Integer)
        {
            CalcFormula = count("CEM Mileage" where("Continia User ID" = field("Continia User ID"),
                                                     Status = filter(Released),
                                                     Posted = const(false),
                                                     "Settlement No." = filter('')));
            Caption = 'Mileage Ready for Posting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Mil. Amt. Pending Users (LCY)"; Decimal)
        {
            CalcFormula = sum("CEM Mileage"."Amount (LCY)" where(Status = filter("Pending Expense User"),
                                                                  "Continia User ID" = field("Continia User ID"),
                                                                  "Settlement No." = filter(''),
                                                                  Posted = const(false)));
            Caption = 'Mileage Amount Pending Users (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Mil.Amt. Pending App (LCY)"; Decimal)
        {
            CalcFormula = sum("CEM Mileage"."Amount (LCY)" where("Continia User ID" = field("Continia User ID"),
                                                                  Status = filter("Pending Approval"),
                                                                  Posted = const(false),
                                                                  "Settlement No." = filter('')));
            Caption = 'Mileage Amount Pending Approval (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Mil. Amt. Ready To Post (LCY)"; Decimal)
        {
            CalcFormula = sum("CEM Mileage"."Amount (LCY)" where(Status = filter(Released),
                                                                  "Continia User ID" = field("Continia User ID"),
                                                                  Posted = const(false),
                                                                  "Settlement No." = filter('')));
            Caption = 'Mileage Amount Ready to Post (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Open Settlements"; Integer)
        {
            CalcFormula = count("CEM Expense Header" where("Continia User ID" = field("Continia User ID"),
                                                            Status = const(Open),
                                                            "Document Type" = const(Settlement)));
            Caption = 'Open Settlements';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Settlements Pending Users"; Integer)
        {
            CalcFormula = count("CEM Expense Header" where("Continia User ID" = field("Continia User ID"),
                                                            Status = const("Pending Expense User"),
                                                            "Document Type" = const(Settlement)));
            Caption = 'Settlements Pending Users';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Settlements Ready for Posting"; Integer)
        {
            CalcFormula = count("CEM Expense Header" where("Continia User ID" = field("Continia User ID"),
                                                            Status = filter(Released),
                                                            Posted = const(false),
                                                            "Document Type" = const(Settlement)));
            Caption = 'Settlements Ready for Posting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Expenses Pending Approval"; Integer)
        {
            CalcFormula = count("CEM Expense" where("Continia User ID" = field("Continia User ID"),
                                                     Status = filter("Pending Approval"),
                                                     Posted = const(false),
                                                     "Settlement No." = filter('')));
            Caption = 'Expenses Pending Approval';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Mileage Pending Approval"; Integer)
        {
            CalcFormula = count("CEM Mileage" where("Continia User ID" = field("Continia User ID"),
                                                     Status = filter("Pending Approval"),
                                                     Posted = const(false),
                                                     "Settlement No." = filter('')));
            Caption = 'Mileage Pending Approval';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Settlements Pending Approval"; Integer)
        {
            CalcFormula = count("CEM Expense Header" where("Continia User ID" = field("Continia User ID"),
                                                            Status = const("Pending Approval"),
                                                            "Document Type" = const(Settlement)));
            Caption = 'Settlements Pending Approval';
            FieldClass = FlowField;
        }
        field(20; "Expense Amount - Open (LCY)"; Decimal)
        {
            CalcFormula = sum("CEM Expense"."Amount (LCY)" where(Status = filter(Open),
                                                                  "Continia User ID" = field("Continia User ID"),
                                                                  Posted = const(false),
                                                                  "Settlement No." = filter('')));
            Caption = 'Expense Amount - Open (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Mileage Amount - Open (LCY)"; Decimal)
        {
            CalcFormula = sum("CEM Mileage"."Amount (LCY)" where(Status = filter(Open),
                                                                  "Continia User ID" = field("Continia User ID"),
                                                                  Posted = const(false),
                                                                  "Settlement No." = filter('')));
            Caption = 'Mileage Amount - Open (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Open Per Diem"; Integer)
        {
            CalcFormula = count("CEM Per Diem" where("Continia User ID" = field("Continia User ID"),
                                                      Status = const(Open),
                                                      "Settlement No." = filter(''),
                                                      Posted = const(false)));
            Caption = 'Open Mileage';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Per Diem Pending Users"; Integer)
        {
            CalcFormula = count("CEM Per Diem" where("Continia User ID" = field("Continia User ID"),
                                                      Status = filter("Pending Expense User"),
                                                      "Settlement No." = filter(''),
                                                      Posted = const(false)));
            Caption = 'Per Diem Pending Users';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Per Diem Pending Approval"; Integer)
        {
            CalcFormula = count("CEM Per Diem" where("Continia User ID" = field("Continia User ID"),
                                                      Status = filter("Pending Approval"),
                                                      Posted = const(false),
                                                      "Settlement No." = filter('')));
            Caption = 'Per Diem Pending Approval';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Per Diem Ready for Posting"; Integer)
        {
            CalcFormula = count("CEM Per Diem" where("Continia User ID" = field("Continia User ID"),
                                                      Status = filter(Released),
                                                      Posted = const(false),
                                                      "Settlement No." = filter('')));
            Caption = 'Per Diem Ready for Posting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Settlements Not Posted"; Integer)
        {
            CalcFormula = count("CEM Expense Header" where("Continia User ID" = field("Continia User ID"),
                                                            Posted = const(false),
                                                            "Document Type" = const(Settlement)));
            Caption = 'Settlements Not Posted';
            FieldClass = FlowField;
        }
        field(27; "Expenses Not Posted"; Integer)
        {
            CalcFormula = count("CEM Expense" where("Continia User ID" = field("Continia User ID"),
                                                     "Settlement No." = filter(''),
                                                     Posted = const(false)));
            Caption = 'Expenses Not Posted';
            FieldClass = FlowField;
        }
        field(28; "Mileages Not Posted"; Integer)
        {
            CalcFormula = count("CEM Mileage" where("Continia User ID" = field("Continia User ID"),
                                                     "Settlement No." = filter(''),
                                                     Posted = const(false)));
            Caption = 'Mileage Not Posted';
            FieldClass = FlowField;
        }
        field(29; "Per Diems Not Posted"; Integer)
        {
            CalcFormula = count("CEM Per Diem" where("Continia User ID" = field("Continia User ID"),
                                                      "Settlement No." = filter(''),
                                                      Posted = const(false)));
            Caption = 'Per Diems Not Posted';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Continia User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetPerDiemAmtOpen(ContiniaUserID: Code[50]) "Sum": Decimal
    begin
    end;

    procedure GetPerDiemAmtPendingUser(ContiniaUserID: Code[50]) "Sum": Decimal
    begin
    end;

    procedure GetPerDiemAmtPendingApproval(ContiniaUserID: Code[50]) "Sum": Decimal
    begin
    end;

    procedure GetPerDiemAmtPendingPosting(ContiniaUserID: Code[50]) "Sum": Decimal
    begin
    end;
}