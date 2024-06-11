table 12032001 "DC - Document Layout"
{
    Caption = 'Document Layout';

    fields
    {
        field(1; "No."; Code[10])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                TestStatus();
            end;
        }
        field(3; "Report No."; Integer)
        {
            Caption = 'Report No.';
        }
        field(4; "Report Name"; Text[30])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Report), "Object ID" = field("Report No.")));
            Caption = 'Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Document Label Code"; Code[20])
        {
            Caption = 'Document Label Code';
        }
        field(6; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(7; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                TestStatus();
            end;
        }
        field(8; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'New,Certified,Under Development,Closed';
            OptionMembers = New,Certified,"Under Development",Closed;
        }
        field(9; "Top DataItem Table No."; Integer)
        {
            Caption = 'Top DataItem Table No.';
        }
        field(10; "Top DataItem Table Name"; Text[30])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Table),
                                                                        "Object ID" = field("Top DataItem Table No.")));
            Caption = 'Top DataItem Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Page Height (Lines)"; Integer)
        {
            Caption = 'Page Height (lines)';

            trigger OnValidate()
            begin
                TestStatus();
            end;
        }
        field(12; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
            Editable = false;
        }
        field(13; "Last Modified by User ID"; Code[100])
        {
            Caption = 'Last Modified by User ID';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;

            trigger OnLookup()
            var
                LoginMng: Codeunit "User Management";
                UserID: Code[20];
            begin
                UserID := "Last Modified by User ID";
                LoginMng.LookupUserID(UserID);
            end;
        }
        field(14; "Print from Preview"; Boolean)
        {
            Caption = 'Print from Preview';

            trigger OnValidate()
            begin
                TestStatus();
            end;
        }
        field(15; "Page Width (pt)"; Integer)
        {
            Caption = 'Page Width (pt)';

            trigger OnValidate()
            begin
                TestStatus();
            end;
        }
        field(16; "Phantom Layout"; Boolean)
        {
            Caption = 'Phantom Layout';

            trigger OnValidate()
            begin
                TestStatus();

                if "Phantom Layout" then begin
                    TestField("Report No.", 0);
                    TestField("Document Label Code", '');
                    TestField("Page Height (Lines)", 0);
                    TestField("Page Width (pt)", 0);
                    TestField("Print from Preview", false);
                end;
            end;
        }
        field(17; "Font Family"; Text[30])
        {
            Caption = 'Font Family';
        }
        field(18; "Font Size"; Integer)
        {
            Caption = 'Font Size';
        }
        field(19; "Render Report No."; Integer)
        {
            Caption = 'Render Report No.';
        }
        field(20; "Render Report Name"; Text[30])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Report), "Object ID" = field("Render Report No.")));
            Caption = 'Render Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Quickview Bitmap"; BLOB)
        {
            Caption = 'Quickview Bitmap';
            SubType = Bitmap;
        }
        field(22; "Last Modified Time"; Time)
        {
            Caption = 'Last Modification Time';
            Editable = false;
        }
        field(50; "Flow Layout"; Boolean)
        {
            CalcFormula = exist(AllObj where("Object Type" = const(Report),
                                              "Object ID" = field("Render Report No."),
                                              "Object Name" = filter('*Flow*')));
            Caption = 'Rendering Report Uses Flow Layout';
            Editable = false;
            FieldClass = FlowField;
        }
        field(55; "Carry Over Format"; Text[30])
        {
            Caption = 'Carry Over Format';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Report No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        DocumentLayoutCodeunit: Record "DC - Document Layout Codeunit";
        DocumentLayoutCriteria: Record "DC - Document Layout Criterion";
        DocumentLayoutField: Record "DC - Document Layout Field";
        DocumentLayoutFilter: Record "DC - Document Layout Filter";
        DocumentLayoutLine: Record "DC - Document Layout Line";
        DocumentLayoutVariable: Record "DC - Document Layout Variable";
    begin
        DocumentLayoutLine.SetRange("Layout No.", "No.");
        DocumentLayoutLine.DeleteAll(true);

        DocumentLayoutField.SetRange("Layout No.", "No.");
        DocumentLayoutField.DeleteAll(true);

        DocumentLayoutFilter.SetRange("Layout No.", "No.");
        DocumentLayoutFilter.DeleteAll(true);

        DocumentLayoutCriteria.SetRange("Layout No.", "No.");
        DocumentLayoutCriteria.DeleteAll(true);

        DocumentLayoutVariable.SetRange("Layout No.", "No.");
        DocumentLayoutVariable.DeleteAll(true);

        DocumentLayoutCodeunit.SetRange("Layout No.", "No.");
        DocumentLayoutCodeunit.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        "Last Modified Date" := Today;
        "Last Modified by User ID" := UserId;

        "Last Modified Time" := Time;
    end;

    trigger OnModify()
    begin
        "Last Modified Date" := Today;
        "Last Modified by User ID" := UserId;

        "Last Modified Time" := Time;
    end;

    var
        Text001: Label 'Copy a Document Layout will replace the existing one. Continue?';
        Text002: Label 'Validating Document Layout!';


    procedure Caption(): Text[120]
    begin
        exit(StrSubstNo('%1 %2', "No.", Description));
    end;


    procedure CopyLayout()
    begin
    end;

    procedure RunReport(FormattedDocument: Boolean)
    begin
    end;

    procedure TestStatus()
    begin
    end;

    procedure ValidateLayout()
    begin
    end;

    procedure FieldExists(TableNo: Integer; FieldNo: Integer)
    begin
    end;

    procedure LaunchQuickView(Type: Integer)
    begin
    end;
}