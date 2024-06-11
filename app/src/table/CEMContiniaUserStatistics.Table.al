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
            CalcFormula = Count("CEM Expense" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                     Status = FILTER("Pending Expense User"),
                                                     Posted = CONST(false),
                                                     "Settlement No." = FILTER('')));
            Caption = 'Expenses Pending Users';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Exp. Amt. Pending Users (LCY)"; Decimal)
        {
            CalcFormula = Sum("CEM Expense"."Amount (LCY)" WHERE(Status = FILTER("Pending Expense User"),
                                                                  "Continia User ID" = FIELD("Continia User ID"),
                                                                  Posted = CONST(false),
                                                                  "Settlement No." = FILTER('')));
            Caption = 'Expense Amount Pending Users (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Exp.Amt. Pending App (LCY)"; Decimal)
        {
            CalcFormula = Sum("CEM Expense"."Amount (LCY)" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                                  Status = FILTER("Pending Approval"),
                                                                  Posted = CONST(false),
                                                                  "Settlement No." = FILTER('')));
            Caption = 'Expense Amount Pending Approval (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Exp. Amt. Ready To Post (LCY)"; Decimal)
        {
            CalcFormula = Sum("CEM Expense"."Amount (LCY)" WHERE(Status = FILTER(Released),
                                                                  "Continia User ID" = FIELD("Continia User ID"),
                                                                  Posted = CONST(false),
                                                                  "Settlement No." = FILTER('')));
            Caption = 'Expense Amount Ready To Post (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Open Expenses"; Integer)
        {
            CalcFormula = Count("CEM Expense" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                     Status = CONST(Open),
                                                     "Settlement No." = FILTER(''),
                                                     Posted = CONST(false)));
            Caption = 'Open Expenses';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Expenses Ready for Posting"; Integer)
        {
            CalcFormula = Count("CEM Expense" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                     Status = FILTER(Released),
                                                     Posted = CONST(false),
                                                     "Settlement No." = FILTER('')));
            Caption = 'Expenses Ready for Posting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Open Mileage"; Integer)
        {
            CalcFormula = Count("CEM Mileage" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                     Status = CONST(Open),
                                                     "Settlement No." = FILTER(''),
                                                     Posted = CONST(false)));
            Caption = 'Open Mileage';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Mileage Pending Users"; Integer)
        {
            CalcFormula = Count("CEM Mileage" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                     Status = FILTER("Pending Expense User"),
                                                     "Settlement No." = FILTER(''),
                                                     Posted = CONST(false)));
            Caption = 'Mileage Pending Users';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Mileage Ready for Posting"; Integer)
        {
            CalcFormula = Count("CEM Mileage" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                     Status = FILTER(Released),
                                                     Posted = CONST(false),
                                                     "Settlement No." = FILTER('')));
            Caption = 'Mileage Ready for Posting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Mil. Amt. Pending Users (LCY)"; Decimal)
        {
            CalcFormula = Sum("CEM Mileage"."Amount (LCY)" WHERE(Status = FILTER("Pending Expense User"),
                                                                  "Continia User ID" = FIELD("Continia User ID"),
                                                                  "Settlement No." = FILTER(''),
                                                                  Posted = CONST(false)));
            Caption = 'Mileage Amount Pending Users (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Mil.Amt. Pending App (LCY)"; Decimal)
        {
            CalcFormula = Sum("CEM Mileage"."Amount (LCY)" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                                  Status = FILTER("Pending Approval"),
                                                                  Posted = CONST(false),
                                                                  "Settlement No." = FILTER('')));
            Caption = 'Mileage Amount Pending Approval (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Mil. Amt. Ready To Post (LCY)"; Decimal)
        {
            CalcFormula = Sum("CEM Mileage"."Amount (LCY)" WHERE(Status = FILTER(Released),
                                                                  "Continia User ID" = FIELD("Continia User ID"),
                                                                  Posted = CONST(false),
                                                                  "Settlement No." = FILTER('')));
            Caption = 'Mileage Amount Ready to Post (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Open Settlements"; Integer)
        {
            CalcFormula = Count("CEM Expense Header" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                            Status = CONST(Open),
                                                            "Document Type" = CONST(Settlement)));
            Caption = 'Open Settlements';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Settlements Pending Users"; Integer)
        {
            CalcFormula = Count("CEM Expense Header" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                            Status = CONST("Pending Expense User"),
                                                            "Document Type" = CONST(Settlement)));
            Caption = 'Settlements Pending Users';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Settlements Ready for Posting"; Integer)
        {
            CalcFormula = Count("CEM Expense Header" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                            Status = FILTER(Released),
                                                            Posted = CONST(false),
                                                            "Document Type" = CONST(Settlement)));
            Caption = 'Settlements Ready for Posting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Expenses Pending Approval"; Integer)
        {
            CalcFormula = Count("CEM Expense" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                     Status = FILTER("Pending Approval"),
                                                     Posted = CONST(false),
                                                     "Settlement No." = FILTER('')));
            Caption = 'Expenses Pending Approval';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Mileage Pending Approval"; Integer)
        {
            CalcFormula = Count("CEM Mileage" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                     Status = FILTER("Pending Approval"),
                                                     Posted = CONST(false),
                                                     "Settlement No." = FILTER('')));
            Caption = 'Mileage Pending Approval';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Settlements Pending Approval"; Integer)
        {
            CalcFormula = Count("CEM Expense Header" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                            Status = CONST("Pending Approval"),
                                                            "Document Type" = CONST(Settlement)));
            Caption = 'Settlements Pending Approval';
            FieldClass = FlowField;
        }
        field(20; "Expense Amount - Open (LCY)"; Decimal)
        {
            CalcFormula = Sum("CEM Expense"."Amount (LCY)" WHERE(Status = FILTER(Open),
                                                                  "Continia User ID" = FIELD("Continia User ID"),
                                                                  Posted = CONST(false),
                                                                  "Settlement No." = FILTER('')));
            Caption = 'Expense Amount - Open (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Mileage Amount - Open (LCY)"; Decimal)
        {
            CalcFormula = Sum("CEM Mileage"."Amount (LCY)" WHERE(Status = FILTER(Open),
                                                                  "Continia User ID" = FIELD("Continia User ID"),
                                                                  Posted = CONST(false),
                                                                  "Settlement No." = FILTER('')));
            Caption = 'Mileage Amount - Open (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Open Per Diem"; Integer)
        {
            CalcFormula = Count("CEM Per Diem" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                      Status = CONST(Open),
                                                      "Settlement No." = FILTER(''),
                                                      Posted = CONST(false)));
            Caption = 'Open Mileage';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Per Diem Pending Users"; Integer)
        {
            CalcFormula = Count("CEM Per Diem" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                      Status = FILTER("Pending Expense User"),
                                                      "Settlement No." = FILTER(''),
                                                      Posted = CONST(false)));
            Caption = 'Per Diem Pending Users';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Per Diem Pending Approval"; Integer)
        {
            CalcFormula = Count("CEM Per Diem" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                      Status = FILTER("Pending Approval"),
                                                      Posted = CONST(false),
                                                      "Settlement No." = FILTER('')));
            Caption = 'Per Diem Pending Approval';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Per Diem Ready for Posting"; Integer)
        {
            CalcFormula = Count("CEM Per Diem" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                      Status = FILTER(Released),
                                                      Posted = CONST(false),
                                                      "Settlement No." = FILTER('')));
            Caption = 'Per Diem Ready for Posting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Settlements Not Posted"; Integer)
        {
            CalcFormula = Count("CEM Expense Header" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                            Posted = CONST(false),
                                                            "Document Type" = CONST(Settlement)));
            Caption = 'Settlements Not Posted';
            FieldClass = FlowField;
        }
        field(27; "Expenses Not Posted"; Integer)
        {
            CalcFormula = Count("CEM Expense" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                     "Settlement No." = FILTER(''),
                                                     Posted = CONST(false)));
            Caption = 'Expenses Not Posted';
            FieldClass = FlowField;
        }
        field(28; "Mileages Not Posted"; Integer)
        {
            CalcFormula = Count("CEM Mileage" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                     "Settlement No." = FILTER(''),
                                                     Posted = CONST(false)));
            Caption = 'Mileage Not Posted';
            FieldClass = FlowField;
        }
        field(29; "Per Diems Not Posted"; Integer)
        {
            CalcFormula = Count("CEM Per Diem" WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                      "Settlement No." = FILTER(''),
                                                      Posted = CONST(false)));
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
    var
        PerDiem: Record "CEM Per Diem";
    begin
        PerDiem.SetRange("Continia User ID", ContiniaUserID);
        PerDiem.SetRange(Status, PerDiem.Status::Open);
        PerDiem.SetRange(Posted, false);
        PerDiem.SetRange("Settlement No.", '');
        if PerDiem.FindSet then
            repeat
                PerDiem.CalcFields("Amount (LCY)");
                Sum += PerDiem."Amount (LCY)";
            until PerDiem.Next = 0;
    end;


    procedure GetPerDiemAmtPendingUser(ContiniaUserID: Code[50]) "Sum": Decimal
    var
        PerDiem: Record "CEM Per Diem";
    begin
        PerDiem.SetRange("Continia User ID", ContiniaUserID);
        PerDiem.SetRange(Status, PerDiem.Status::"Pending Expense User");
        PerDiem.SetRange(Posted, false);
        PerDiem.SetRange("Settlement No.", '');
        if PerDiem.FindSet then
            repeat
                PerDiem.CalcFields("Amount (LCY)");
                Sum += PerDiem."Amount (LCY)";
            until PerDiem.Next = 0;
    end;


    procedure GetPerDiemAmtPendingApproval(ContiniaUserID: Code[50]) "Sum": Decimal
    var
        PerDiem: Record "CEM Per Diem";
    begin
        PerDiem.SetRange("Continia User ID", ContiniaUserID);
        PerDiem.SetRange(Status, PerDiem.Status::"Pending Approval");
        PerDiem.SetRange(Posted, false);
        PerDiem.SetRange("Settlement No.", '');
        if PerDiem.FindSet then
            repeat
                PerDiem.CalcFields("Amount (LCY)");
                Sum += PerDiem."Amount (LCY)";
            until PerDiem.Next = 0;
    end;


    procedure GetPerDiemAmtPendingPosting(ContiniaUserID: Code[50]) "Sum": Decimal
    var
        PerDiem: Record "CEM Per Diem";
    begin
        PerDiem.SetRange("Continia User ID", ContiniaUserID);
        PerDiem.SetRange(Status, PerDiem.Status::Released);
        PerDiem.SetRange(Posted, false);
        PerDiem.SetRange("Settlement No.", '');
        if PerDiem.FindSet then
            repeat
                PerDiem.CalcFields("Amount (LCY)");
                Sum += PerDiem."Amount (LCY)";
            until PerDiem.Next = 0;
    end;
}

