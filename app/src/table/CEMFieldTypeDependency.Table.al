table 6086405 "CEM Field Type Dependency"
{
    Caption = 'Field Type Dependency';

    fields
    {
        field(10; "Field Type Code"; Code[20])
        {
            Caption = 'Field Type Code';
            TableRelation = "CEM Field Type";

        }
        field(11; Condition; Option)
        {
            Caption = 'Condition';
            InitValue = "Has any value";
            OptionCaption = 'Has a specific value,Has any value';
            OptionMembers = "Has a specific value","Has any value";

            trigger OnValidate()
            begin
                if Condition = Condition::"Has any value" then
                    Value := '';

                if Condition = Condition::"Has a specific value" then
                    SpecificValuesAllowedCheck("Field Type Code");
            end;
        }
        field(12; Value; Code[50])
        {
            Caption = 'Value';
            TableRelation = "CEM Lookup Value".Code where("Field Type Code" = field("Field Type Code"));

            trigger OnValidate()
            begin
                if Condition = Condition::"Has any value" then
                    Value := '';
            end;
        }
        field(20; "Reference Field Type Code"; Code[20])
        {
            Caption = 'Reference Field Type Code';
        }
        field(21; Expectation; Option)
        {
            Caption = 'Expectation';
            OptionCaption = 'Must have a value,Must have a specific value,Must have no value';
            OptionMembers = "Must have a value","Must have a specific value","Must have no value";

            trigger OnValidate()
            begin
                SystemDependencyCheck(Rec);

                if (Expectation in [Expectation::"Must have no value", Expectation::"Must have a value"]) then
                    "Expected Value" := '';

                if Expectation = Expectation::"Must have a specific value" then
                    SpecificValuesAllowedCheck("Reference Field Type Code");
            end;
        }
        field(22; "Expected Value"; Code[50])
        {
            Caption = 'Expected Value';
            TableRelation = "CEM Lookup Value".Code where("Field Type Code" = field("Reference Field Type Code"));

            trigger OnValidate()
            begin
                SystemDependencyCheck(Rec);

                if (Expectation in [Expectation::"Must have no value", Expectation::"Must have a value"]) then
                    "Expected Value" := '';
            end;
        }
        field(30; "System Created Dependency"; Boolean)
        {
            BlankZero = true;
            Caption = 'System Created';
            Editable = false;
        }
        field(31; Disabled; Boolean)
        {
            Caption = 'Disabled';
            Editable = false;
        }
        field(32; "Detected Conflicts"; Text[250])
        {
            Caption = 'Detected Conflicts';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Field Type Code", Condition, Value, "Reference Field Type Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "System Created Dependency" then
            Error(DontDeleteSystemDependencyErr);
    end;

    trigger OnInsert()
    begin
        FieldDependencyFirstCheck(Rec);
    end;

    trigger OnModify()
    begin
        FieldDependencyFirstCheck(Rec);
    end;

    trigger OnRename()
    begin
        SystemDependencyCheck(Rec);
        FieldDependencyFirstCheck(Rec);
    end;

    var
        ConflictDetectedAnyValueMsg: Label 'Conflicting dependency expects the %1 %2 to have a value.';
        ConflictDetectedNoValueMsg: Label 'Conflicting dependency expects the %1 %2 to have no value.';
        ConflictingRuleDetectedMsg: Label 'Conflicting expectations to %1 %2. Specific values %3.';
        DataTypeNotSupportedErr: Label 'Data type %1 is currently not supported in field dependencies. %2: %3.';
        DependenciesConsistencyCheck: Label 'Consistency check of dependencies was successful. ';
        DependenciesUpdatedMsg: Label 'Default dimensions and attendees on expense types have been set as system dependencies.';
        DontChangeSystemDependencyErr: Label 'You are not allowed to change a system created dependency.';
        DontDeleteSystemDependencyErr: Label 'You are not allowed to delete a system created dependency.';
        ElementContainSeparatorErr: Label 'Could not add the element (%1) to the list (%2). Element contains the separator (%3).';
        FieldsAreNotConfigured: Label '%1 and %2 are never configured together on the same document type.';
        IssuesDetectedForDependencies: Label 'Issues detected for dependencies for the following fields: %1.';
        LastElementAdded: Label '%1 and %2';
        MandatoryFieldTypeErr: Label 'The field type %1 is mandatory. Expecting it to have no value is conflicting.';
        RecursionDetectedMsg: Label 'Circular dependencies detected for field types %1.';
        RunConsistencyCheck: Label 'Run the Consistency Check action to enable this dependency.';
        SpecificValuesDataTypeErr: Label 'Specific values can only be specified for Field Types of data type Code. %1 has data type %2.';
        SpecificValuesNoValuesErr: Label 'Specific values can only be specified for Field Types that have Lookup Values. %1 has no lookup values.';
        UserGrpWithourLookupAccessErr: Label 'The following user groups don''t have access to value %2 in the field %3:\%1';
        UsersWithourLookupAccessErr: Label 'The following users don''t have access to value %2 in the field %3:\%1';


    procedure SetupConsistencyCheck(var SuccessStatus: Boolean; var ErrorCollector: Text[1024])
    var
        FieldTypeDependency: Record "CEM Field Type Dependency";
    begin
        SuccessStatus := true;
        if FieldTypeDependency.FindSet() then
            repeat
                FieldDependencySecondCheck(FieldTypeDependency);
                IterativelyBuildConflictingSet(FieldTypeDependency);
                IterativelyBuildDependencySet(FieldTypeDependency);
                FieldTypeDependency.Modify();

                if FieldTypeDependency.Disabled then
                    AddKeyToFilter(ErrorCollector, FieldTypeDependency."Field Type Code");

                SuccessStatus := SuccessStatus and not FieldTypeDependency.Disabled;
            until (FieldTypeDependency.Next() = 0);

        ConvertFilterToList(ErrorCollector);
    end;


    procedure SystemDependencyCheck(FieldTypeDependency: Record "CEM Field Type Dependency")
    begin
        if FieldTypeDependency."System Created Dependency" then
            Error(DontChangeSystemDependencyErr);
    end;


    procedure DisabledDependenciesExist(var DetectedConflictMessage: Text[1024]): Boolean
    var
        FieldTypeDependency: Record "CEM Field Type Dependency";
    begin
        Clear(DetectedConflictMessage);

        FieldTypeDependency.SetRange(Disabled, true);
        if FieldTypeDependency.FindFirst() then begin
            DetectedConflictMessage := FieldTypeDependency."Detected Conflicts";
            exit(true);
        end;
    end;


    procedure FieldDependencyFirstCheck(var FieldTypeDependency: Record "CEM Field Type Dependency")
    begin
        FieldTypeDependency.Disabled := true;
        FieldTypeDependency."Detected Conflicts" := RunConsistencyCheck;
        MissingInformationCheck(FieldTypeDependency);
        DirectRecursionCheck(FieldTypeDependency);
    end;


    procedure FieldDependencySecondCheck(var FieldTypeDependency: Record "CEM Field Type Dependency")
    begin
        FieldTypeDependency.Disabled := false;
        FieldTypeDependency."Detected Conflicts" := '';
        DataTypeCheck(FieldTypeDependency);
        FieldTypeMandatoryCheck(FieldTypeDependency);
        LookupValueAccessCheck(FieldTypeDependency);
        ConfiguredFieldTypeCheck(FieldTypeDependency);
    end;


    procedure MissingInformationCheck(FieldTypeDependency: Record "CEM Field Type Dependency")
    begin
        FieldTypeDependency.TestField("Field Type Code");
        FieldTypeDependency.TestField("Reference Field Type Code");

        if FieldTypeDependency.Condition = Condition::"Has a specific value" then
            FieldTypeDependency.TestField(Value);

        if FieldTypeDependency.Expectation = Expectation::"Must have a specific value" then
            FieldTypeDependency.TestField("Expected Value");
    end;


    procedure DataTypeCheck(var FieldTypeDependency: Record "CEM Field Type Dependency")
    var
        FieldType: Record "CEM Field Type";
        ReferenceFieldType: Record "CEM Field Type";
        ErrorMessage: Text[250];
    begin
        if not FieldType.Get(FieldTypeDependency."Field Type Code") then
            exit;
        if not ReferenceFieldType.Get(FieldTypeDependency."Reference Field Type Code") then
            exit;

        if not AllowedDataType(FieldType.Type) then begin
            FieldTypeDependency.Disabled := true;
            ErrorMessage :=
              CopyStr(
                StrSubstNo(DataTypeNotSupportedErr,
                  Format(FieldType.Type),
                  FieldCaption("Field Type Code"),
                  FieldTypeDependency."Field Type Code"),
                1, MaxStrLen(ErrorMessage));
            AddMessageToList(FieldTypeDependency."Detected Conflicts", ErrorMessage);
            exit;
        end;

        if not AllowedDataType(ReferenceFieldType.Type) then begin
            FieldTypeDependency.Disabled := true;
            ErrorMessage :=
              CopyStr(
                StrSubstNo(DataTypeNotSupportedErr,
                  Format(ReferenceFieldType.Type),
                  FieldCaption("Reference Field Type Code"),
                  FieldTypeDependency."Reference Field Type Code"),
                1, MaxStrLen(ErrorMessage));
            AddMessageToList(FieldTypeDependency."Detected Conflicts", ErrorMessage);
        end;
    end;


    procedure AllowedDataType(DataType: Option "Integer",Text,"Code",Decimal,Option,Boolean,Date,Address,Attendees,DateTime): Boolean
    begin
        exit((DataType in [DataType::Code, DataType::Attendees]));
    end;


    procedure LookupDataType(DataType: Option "Integer",Text,"Code",Decimal,Option,Boolean,Date,Address,Attendees,DateTime): Boolean
    begin
        exit(DataType = DataType::Code);
    end;


    procedure SpecificValuesAllowedCheck(FieldTypeCode: Code[20])
    var
        FieldType: Record "CEM Field Type";
    begin
        if not FieldType.Get(FieldTypeCode) then
            exit;

        if not LookupDataType(FieldType.Type) then
            Error(SpecificValuesDataTypeErr, FieldTypeCode, Format(FieldType.Type));

        FieldType.CalcFields("No. of Lookup Values");
        if not (FieldType."No. of Lookup Values" > 0) then
            Error(SpecificValuesNoValuesErr, FieldTypeCode);
    end;


    procedure ConfiguredFieldTypeCheck(var FieldTypeDependency: Record "CEM Field Type Dependency")
    var
        ConfiguredFieldType: Record "CEM Configured Field Type";
        Found: Boolean;
        ErrorMessage: Text[250];
    begin
        if DirectRecursionDetected(FieldTypeDependency) then
            exit;
        if not DependencyIsUsed(FieldTypeDependency) then begin
            FieldTypeDependency.Disabled := true;
            ErrorMessage :=
              CopyStr(
                StrSubstNo(FieldsAreNotConfigured,
                  FieldTypeDependency."Field Type Code",
                  FieldTypeDependency."Reference Field Type Code"),
                1, MaxStrLen(ErrorMessage));
            AddMessageToList(FieldTypeDependency."Detected Conflicts", ErrorMessage);
        end;
    end;


    procedure FieldTypeMandatoryCheck(var FieldTypeDependency: Record "CEM Field Type Dependency")
    var
        FieldType: Record "CEM Field Type";
        ErrorMessage: Text[250];
    begin
        if not (FieldTypeDependency.Expectation = FieldTypeDependency.Expectation::"Must have no value") then
            exit;

        if not FieldType.Get(FieldTypeDependency."Reference Field Type Code") then
            exit;

        if FieldType.Mandatory then begin
            FieldTypeDependency.Disabled := true;
            ErrorMessage :=
              CopyStr(
                StrSubstNo(MandatoryFieldTypeErr, FieldType.Code),
                1, MaxStrLen(ErrorMessage));
            AddMessageToList(FieldTypeDependency."Detected Conflicts", ErrorMessage);
        end;
    end;


    procedure LookupValueAccessCheck(var FieldTypeDependency: Record "CEM Field Type Dependency")
    var
        FieldType: Record "CEM Field Type";
        LookupValueAccess: Record "CEM Lookup Value Access";
        ErrorMessage: Text[250];
        ListOfGroups: Text[1024];
        ListOfUsers: Text[1024];
    begin
        if not (FieldTypeDependency.Expectation = FieldTypeDependency.Expectation::"Must have a specific value") then
            exit;

        FieldType.Get(FieldTypeDependency."Reference Field Type Code");
        if not LookupDataType(FieldType.Type) then
            exit;

        LookupValueAccess.SetRange("Field Type Code", FieldTypeDependency."Reference Field Type Code");
        if LookupValueAccess.FindFirst() then
            repeat
                if RestrictedAccessDetected(
                  FieldTypeDependency."Reference Field Type Code",
                  FieldTypeDependency."Expected Value",
                  LookupValueAccess.Type, // Group or User
                  LookupValueAccess.Code)
                then
                    if (LookupValueAccess.Type = LookupValueAccess.Type::Group) then
                        AddKeyToFilter(ListOfGroups, LookupValueAccess.Code)
                    else
                        AddKeyToFilter(ListOfUsers, LookupValueAccess.Code);
            until LookupValueAccess.Next() = 0;

        if ListOfUsers <> '' then begin
            FieldTypeDependency.Disabled := true;
            ErrorMessage :=
              CopyStr(
                StrSubstNo(UsersWithourLookupAccessErr,
                  ConvertFilterToList(ListOfUsers),
                  FieldTypeDependency."Expected Value",
                  FieldTypeDependency."Reference Field Type Code"),
                1, MaxStrLen(ErrorMessage));
            AddMessageToList(FieldTypeDependency."Detected Conflicts", ErrorMessage);
        end;

        if ListOfGroups <> '' then begin
            ErrorMessage :=
              CopyStr(
                StrSubstNo(UserGrpWithourLookupAccessErr,
                  ConvertFilterToList(ListOfGroups),
                  FieldTypeDependency."Expected Value",
                  FieldTypeDependency."Reference Field Type Code"),
                1, MaxStrLen(ErrorMessage));
            AddMessageToList(FieldTypeDependency."Detected Conflicts", ErrorMessage);
        end;
    end;


    procedure RestrictedAccessDetected(FieldTypeCode: Code[20]; ExpectedValue: Code[50]; UserType: Option User,Group; UserCode: Code[50]): Boolean
    var
        LookupValueAccess: Record "CEM Lookup Value Access";
    begin
        LookupValueAccess.SetRange("Field Type Code", FieldTypeCode);
        LookupValueAccess.SetRange(Type, UserType);
        LookupValueAccess.SetRange(Code, UserCode);
        if LookupValueAccess.IsEmpty then
            exit(false);

        LookupValueAccess.SetRange("Value Code", ExpectedValue);
        exit(LookupValueAccess.IsEmpty);
    end;


    procedure ConflictingAndCircularCheck(RunSilent: Boolean) SuccessStatus: Boolean
    var
        ErrorCollector: Text[1024];
    begin
        SetupConsistencyCheck(SuccessStatus, ErrorCollector);
        if RunSilent then
            exit(SuccessStatus);

        if SuccessStatus then
            Message(DependenciesConsistencyCheck)
        else
            Message(IssuesDetectedForDependencies, PrettifyFilterForMsg(ErrorCollector));
    end;

    local procedure AddFieldDependency(FieldTypeCode: Code[20]; Condition: Option "Has a specific value","Has any value"; Value: Code[50]; RefFieldTypeCode: Code[20]; Expectation: Option "Must have a value","Must have a specific value","Value not allowed"; ExpectedValue: Code[50]; SystemCreatedDependency: Boolean)
    var
        FieldTypeDependency: Record "CEM Field Type Dependency";
    begin
        if FieldTypeCode = '' then
            exit;
        if RefFieldTypeCode = '' then
            exit;
        if (Condition = Condition::"Has a specific value") and (Value = '') then
            exit;
        if (Expectation = Expectation::"Must have a specific value") and (ExpectedValue = '') then
            exit;

        if FieldTypeDependency.Get(FieldTypeCode, Condition, Value, RefFieldTypeCode) then
            FieldTypeDependency.Delete();

        FieldTypeDependency.Init();
        FieldTypeDependency."Field Type Code" := FieldTypeCode;
        FieldTypeDependency.Condition := Condition;
        if Condition = Condition::"Has a specific value" then
            FieldTypeDependency.Value := Value;
        FieldTypeDependency."Reference Field Type Code" := RefFieldTypeCode;
        FieldTypeDependency.Expectation := Expectation;
        if Expectation = Expectation::"Must have a specific value" then
            FieldTypeDependency."Expected Value" := ExpectedValue;
        FieldTypeDependency."System Created Dependency" := SystemCreatedDependency;
        FieldDependencyFirstCheck(FieldTypeDependency);
        FieldTypeDependency.Insert();
    end;


    procedure SetupFieldDependencies()
    begin
        UpdateSystemDependencies();
        Message(DependenciesUpdatedMsg);
    end;


    procedure UpdateSystemDependencies()
    begin
    end;

    procedure FieldDependencyConfigured(FieldTypeCode: Code[20]; RefFieldTypeCode: Code[20]): Boolean
    begin
    end;

    procedure MutuallyExclusiveDependencies(Dependency1: Record "CEM Field Type Dependency"; Dependency2: Record "CEM Field Type Dependency") MutuallyExclusive: Boolean
    begin
    end;

    procedure IdenticalDependencies(Dependency1: Record "CEM Field Type Dependency"; Dependency2: Record "CEM Field Type Dependency"): Boolean
    begin
    end;

    procedure OnSameDocumentType(Dependency1: Record "CEM Field Type Dependency"; Dependency2: Record "CEM Field Type Dependency"): Boolean
    begin
    end;

    procedure DependencyIsUsed(Dependency: Record "CEM Field Type Dependency"): Boolean
    begin
    end;

    procedure IsExpenseDependency(Dependency: Record "CEM Field Type Dependency"): Boolean
    begin
    end;

    procedure IsMileageDependency(Dependency: Record "CEM Field Type Dependency"): Boolean
    begin
    end;

    procedure IsPerDiemDependency(Dependency: Record "CEM Field Type Dependency"): Boolean
    var
        ConfiguredFieldType: Record "CEM Configured Field Type";
    begin
        ConfiguredFieldType.SetRange(Type, ConfiguredFieldType.Type::"Per Diem");
        ConfiguredFieldType.SetRange("Sub Type", ConfiguredFieldType."Sub Type"::" ");
        ConfiguredFieldType.SetFilter("Field Code", '%1|%2', Dependency."Field Type Code", Dependency."Reference Field Type Code");
        exit(ConfiguredFieldType.Count = 2);
    end;


    procedure IsSettlementDependency(Dependency: Record "CEM Field Type Dependency"): Boolean
    var
        ConfiguredFieldType: Record "CEM Configured Field Type";
    begin
        ConfiguredFieldType.SetRange(Type, ConfiguredFieldType.Type::Settlement);
        ConfiguredFieldType.SetRange("Sub Type", ConfiguredFieldType."Sub Type"::" ");
        ConfiguredFieldType.SetFilter("Field Code", '%1|%2', Dependency."Field Type Code", Dependency."Reference Field Type Code");
        exit(ConfiguredFieldType.Count = 2);
    end;


    procedure DeleteDependenciesNotNeeded(DocumentType: Option Expense,Mileage,Settlement,"Per Diem"; FieldTypeCode: Code[20])
    var
        DependencyNotUsed: Record "CEM Field Type Dependency";
        FieldTypeDependency: Record "CEM Field Type Dependency";
        UsedElseWhere: Boolean;
    begin
        if FieldTypeDependency.FindSet() then
            repeat
                UsedElseWhere := false;
                if (FieldTypeDependency."Field Type Code" = FieldTypeCode) or
                  (FieldTypeDependency."Reference Field Type Code" = FieldTypeCode) then begin
                    case DocumentType of
                        DocumentType::Expense:
                            begin
                                UsedElseWhere := IsMileageDependency(FieldTypeDependency) or
                                  IsPerDiemDependency(FieldTypeDependency) or
                                  IsSettlementDependency(FieldTypeDependency);
                            end;
                        DocumentType::Mileage:
                            begin
                                UsedElseWhere := IsExpenseDependency(FieldTypeDependency) or
                                  IsPerDiemDependency(FieldTypeDependency) or
                                  IsSettlementDependency(FieldTypeDependency);
                            end;
                        DocumentType::"Per Diem":
                            begin
                                UsedElseWhere := IsExpenseDependency(FieldTypeDependency) or
                                  IsMileageDependency(FieldTypeDependency) or
                                  IsSettlementDependency(FieldTypeDependency);
                            end;
                        DocumentType::Settlement:
                            begin
                                UsedElseWhere := IsExpenseDependency(FieldTypeDependency) or
                                  IsMileageDependency(FieldTypeDependency) or
                                  IsPerDiemDependency(FieldTypeDependency);
                            end;
                    end;
                    if not UsedElseWhere then begin
                        DependencyNotUsed.Get(FieldTypeDependency."Field Type Code",
                          FieldTypeDependency.Condition,
                          FieldTypeDependency.Value,
                          FieldTypeDependency."Reference Field Type Code");
                        DependencyNotUsed.Delete();
                    end;
                end;
            until FieldTypeDependency.Next() = 0;
    end;


    procedure IterativelyBuildConflictingSet(var DependencyBeingChecked: Record "CEM Field Type Dependency")
    var
        FieldTypeDependency: Record "CEM Field Type Dependency";
        OtherDependency: Record "CEM Field Type Dependency";
        AnyValueExpectedFound: Boolean;
        NoValueConflictDetected: Boolean;
        NoValueExpectedFound: Boolean;
        SpecificValueConflictDetected: Boolean;
        SpecificValueExpectedFound: Boolean;
        ErrorMessage: Text[250];
        ExpectedValuesSet: Text[1024];
    begin
        FieldTypeDependency.Reset();
        FieldTypeDependency.SetRange("Reference Field Type Code", DependencyBeingChecked."Reference Field Type Code");
        if FieldTypeDependency.FindFirst() then
            repeat
                if not MutuallyExclusiveDependencies(FieldTypeDependency, DependencyBeingChecked) then begin
                    case FieldTypeDependency.Expectation of
                        FieldTypeDependency.Expectation::"Must have no value":
                            NoValueExpectedFound := true;
                        FieldTypeDependency.Expectation::"Must have a value":
                            AnyValueExpectedFound := true;
                        FieldTypeDependency.Expectation::"Must have a specific value":
                            begin
                                SpecificValueExpectedFound := true;
                                AddKeyToFilter(ExpectedValuesSet, FieldTypeDependency."Expected Value");
                                SpecificValueConflictDetected := CountElementsInFilter(ExpectedValuesSet) > 1;
                            end;
                    end;
                end;
            until (FieldTypeDependency.Next() = 0);

        NoValueConflictDetected := NoValueExpectedFound and (AnyValueExpectedFound or SpecificValueExpectedFound);

        if NoValueConflictDetected then
            if DependencyBeingChecked.Expectation = DependencyBeingChecked.Expectation::"Must have no value" then
                ErrorMessage :=
                  CopyStr(
                    StrSubstNo(ConflictDetectedAnyValueMsg,
                      DependencyBeingChecked.FieldCaption("Reference Field Type Code"),
                      DependencyBeingChecked."Reference Field Type Code"),
                    1, MaxStrLen(ErrorMessage))
            else
                ErrorMessage :=
                  CopyStr(
                    StrSubstNo(ConflictDetectedNoValueMsg,
                      DependencyBeingChecked.FieldCaption("Reference Field Type Code"),
                      DependencyBeingChecked."Reference Field Type Code"),
                    1, MaxStrLen(ErrorMessage))
        else
            if SpecificValueConflictDetected and
              (DependencyBeingChecked.Expectation = DependencyBeingChecked.Expectation::"Must have a specific value") then
                ErrorMessage :=
                  CopyStr(
                    StrSubstNo(ConflictingRuleDetectedMsg,
                      DependencyBeingChecked.FieldCaption("Reference Field Type Code"),
                      DependencyBeingChecked."Reference Field Type Code",
                      PrettifyFilterForMsg(ExpectedValuesSet)),
                    1, MaxStrLen(ErrorMessage));

        if ErrorMessage <> '' then
            AddMessageToList(DependencyBeingChecked."Detected Conflicts", ErrorMessage);
        DependencyBeingChecked.Disabled := DependencyBeingChecked."Detected Conflicts" <> '';
    end;


    procedure IterativelyBuildDependencySet(var DependencyBeingChecked: Record "CEM Field Type Dependency")
    var
        FieldTypeDependency: Record "CEM Field Type Dependency";
        ReferenceDependency: Record "CEM Field Type Dependency";
        RecursionDetected: Boolean;
        StopRecursion: Boolean;
        RecursionDepth: Integer;
        ErrorMessage: Text[250];
        FieldTypeCodeFilter: Text[1024];
        FilterAtBeginning: Text[1024];
    begin
        RecursionDepth := 0;
        StopRecursion := DirectRecursionDetected(DependencyBeingChecked);
        RecursionDetected := StopRecursion;
        FieldTypeCodeFilter := DependencyBeingChecked."Reference Field Type Code";
        while not StopRecursion do begin
            FilterAtBeginning := FieldTypeCodeFilter;
            RecursionDepth += 1;
            RecursionDetected := RecursionDetected or (RecursionDepth >= 40); // Limitied to maximum number of Fields in Filter.

            if not RecursionDetected then begin
                FieldTypeDependency.Reset();
                FieldTypeDependency.SetFilter("Field Type Code", FieldTypeCodeFilter);
                if FieldTypeDependency.FindSet() then
                    repeat
                        if not MutuallyExclusiveDependencies(FieldTypeDependency, DependencyBeingChecked) then begin
                            ReferenceDependency.Reset();
                            ReferenceDependency.SetRange("Field Type Code", FieldTypeDependency."Reference Field Type Code");
                            if not ReferenceDependency.IsEmpty then begin
                                AddKeyToFilter(FieldTypeCodeFilter, FieldTypeDependency."Reference Field Type Code");
                                RecursionDetected := RecursionDetected or
                                  (FieldTypeDependency."Reference Field Type Code" = DependencyBeingChecked."Field Type Code");
                            end;
                        end;
                    until RecursionDetected or (FieldTypeDependency.Next() = 0);
                StopRecursion := StopRecursion or RecursionDetected or (FieldTypeCodeFilter = FilterAtBeginning);
            end;
        end;

        if RecursionDetected then begin
            DependencyBeingChecked.Disabled := true;
            ErrorMessage :=
              CopyStr(
                StrSubstNo(RecursionDetectedMsg, PrettifyFilterForMsg(FieldTypeCodeFilter)),
                1, MaxStrLen(ErrorMessage));
            AddMessageToList(DependencyBeingChecked."Detected Conflicts", ErrorMessage);
        end;
    end;

    local procedure DirectRecursionCheck(DependencyBeingChecked: Record "CEM Field Type Dependency")
    var
        RecursionDetected: Boolean;
        FieldTypeCodeFilter: Text[1024];
    begin
        RecursionDetected := DirectRecursionDetected(DependencyBeingChecked);
        AddKeyToFilter(FieldTypeCodeFilter, DependencyBeingChecked."Field Type Code");
        AddKeyToFilter(FieldTypeCodeFilter, DependencyBeingChecked."Reference Field Type Code");

        if RecursionDetected then
            Error(RecursionDetectedMsg, PrettifyFilterForMsg(FieldTypeCodeFilter));
    end;

    local procedure DirectRecursionDetected(DependencyBeingChecked: Record "CEM Field Type Dependency"): Boolean
    begin
        exit(DependencyBeingChecked."Field Type Code" = DependencyBeingChecked."Reference Field Type Code");
    end;

    local procedure AddMessageToList(var MessageList: Text[250]; Element: Text[250])
    var
        List: Text[1024];
    begin
        List := MessageList;
        AddKeyToFilter(List, Element);
        MessageList := CopyStr(ConvertFilterToList(List), 1, MaxStrLen(MessageList));
    end;

    local procedure AddKeyToFilter(var "Filter": Text[1024]; "Key": Text[250])
    begin
        AddStringToList(Filter, '|', Key);
    end;

    local procedure SelectFirstKeyInFilter(var "Filter": Text[1024]) "Key": Text[1024]
    var
        Pos: Integer;
        Head: Text[1024];
        Tail: Text[1024];
    begin
        Pos := StrPos(Filter, '|');
        if Pos = 0 then begin
            Key := Filter;
            Filter := '';
        end else begin
            Key := CopyStr(Filter, 1, Pos - 1);
            Filter := CopyStr(Filter, Pos + 1);
        end;
    end;

    local procedure CountElementsInFilter(var "Filter": Text[1024]) NumberOfKeys: Integer
    begin
        if Filter = '' then
            exit(0);

        if StrPos(Filter, '|') = 0 then
            exit(1);

        NumberOfKeys := StrLen(Filter) - StrLen(DelChr(Filter, '=', '|')) + 1;
    end;

    local procedure ConvertFilterToList("Filter": Text[1024]): Text[1024]
    begin
        exit(ConvertStr(Filter, '|', ','));
    end;

    local procedure PrettifyFilterForMsg("Filter": Text[1024]): Text[1024]
    var
        NumberOfKeys: Integer;
    begin
        NumberOfKeys := CountElementsInFilter(Filter);
        case NumberOfKeys of
            0:
                exit('');
            1:
                exit(Filter);
            2:
                exit(CopyStr(StrSubstNo(LastElementAdded, SelectFirstKeyInFilter(Filter), Filter), 1, MaxStrLen(Filter)));
            else
                exit(CopyStr(StrSubstNo('%1, %2', SelectFirstKeyInFilter(Filter), PrettifyFilterForMsg(Filter)), 1, MaxStrLen(Filter)));
        end;
    end;

    local procedure AddStringToList(var List: Text[1024]; Separator: Text[10]; Element: Text[250])
    begin
        if List = '' then
            List := Element;

        if StrPos(Element, Separator) > 0 then
            Error(ElementContainSeparatorErr, Element, List, Separator);

        if StrPos(List, Element) = 0 then
            List := CopyStr(List + Separator + Element, 1, MaxStrLen(List));
    end;

    procedure LookupFieldTypeLookupValue(var Text: Text[1024]): Boolean
    var
        LookupValue: Record "CEM Lookup Value";
    begin
        LookupValue.SetRange("Field Type Code", Rec."Reference Field Type Code");
        if LookupValue.Get("Reference Field Type Code", '', Text) then;
        if PAGE.RunModal(0, LookupValue) = ACTION::LookupOK then begin
            Text := LookupValue.Code;
            exit(true);
        end;
    end;
}

