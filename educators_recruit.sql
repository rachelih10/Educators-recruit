-- Educators Recruit - Business Scenario Implementation (T-SQL)

DROP TABLE IF EXISTS dbo.Educator;

CREATE TABLE dbo.Educator (
    EducatorID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender NVARCHAR(20) NULL,
    CollegeAttended NVARCHAR(200) NOT NULL,
    DegreeTitle NVARCHAR(200) NOT NULL,
    MediaSource NVARCHAR(100) NOT NULL,
    DateContacted DATE NOT NULL,
    SchoolPlaced NVARCHAR(200) NULL,
    DateFoundJob DATE NULL,
    CONSTRAINT CK_Educator_DateFoundJob CHECK (DateFoundJob IS NULL OR DateFoundJob >= DateContacted)
);

INSERT INTO dbo.Educator (
    FirstName,
    LastName,
    DateOfBirth,
    Gender,
    CollegeAttended,
    DegreeTitle,
    MediaSource,
    DateContacted,
    SchoolPlaced,
    DateFoundJob
)
VALUES
    (
        'Mary',
        'Lynn',
        '2000-09-13',
        'female',
        'Excelsior College',
        'BA in Mathematics Education',
        'magazine',
        '2022-05-02',
        'Brooklyn High School',
        '2022-05-09'
    ),
    (
        'Josh',
        'Frank',
        '1998-04-23',
        'male',
        'Georgia State University',
        'MA in Social Studies Education',
        'social media',
        '2022-02-12',
        'Manhattan Elementary School',
        '2022-05-09'
    ),
    (
        'Charles',
        'Smith',
        '1994-07-09',
        'male',
        'Excelsior College',
        'PhD in Education',
        'social media',
        '2021-08-07',
        'New York City Day School',
        '2021-08-12'
    ),
    (
        'Samantha',
        'Brown',
        '1999-09-24',
        'female',
        'Columbia University',
        'BA in English Education',
        'newspaper',
        '2021-05-23',
        'Brooklyn High School',
        '2021-07-30'
    ),
    (
        'Howard',
        'Lang',
        '1998-08-04',
        'male',
        'Georgia State University',
        'MA in History Education',
        'word of mouth',
        '2022-01-31',
        NULL,
        NULL
    ),
    (
        'Sarah',
        'Blanks',
        '1995-10-20',
        'female',
        'Columbia University',
        'MA in Science Education',
        'social media',
        '2020-05-23',
        'New York City Day School',
        '2020-08-17'
    ),
    (
        'Ella',
        'Lewis',
        '2000-08-22',
        'female',
        'Excelsior College',
        'BA in English Education',
        'word of mouth',
        '2022-04-01',
        NULL,
        NULL
    ),
    (
        'Julie',
        'Goldman',
        '1997-03-30',
        NULL,
        'University of Denver',
        'MA in Social Studies Education',
        'social media',
        '2020-07-14',
        'Manhattan Elementary School',
        '2020-08-17'
    );

-- Report 1: Number of students from each college placed in under 2 weeks
SELECT
    e.CollegeAttended,
    COUNT(*) AS PlacedUnderTwoWeeks
FROM dbo.Educator AS e
WHERE
    e.DateFoundJob IS NOT NULL
    AND DATEDIFF(DAY, e.DateContacted, e.DateFoundJob) <= 14
GROUP BY e.CollegeAttended
ORDER BY PlacedUnderTwoWeeks DESC;

-- Report 2: Placement success by gender
SELECT
    e.Gender,
    COUNT(*) AS Placements
FROM dbo.Educator AS e
WHERE e.DateFoundJob IS NOT NULL
GROUP BY e.Gender
ORDER BY Placements DESC;

-- Report 3: Average contacts per day and counts per media source
SELECT
    CAST(COUNT(*) AS DECIMAL(10,2)) / NULLIF(COUNT(DISTINCT e.DateContacted), 0) AS AvgContactsPerDay
FROM dbo.Educator AS e;

SELECT
    e.MediaSource,
    COUNT(*) AS Contacts
FROM dbo.Educator AS e
GROUP BY e.MediaSource
ORDER BY Contacts DESC;

-- Report 4: Average placements per day
SELECT
    CAST(COUNT(*) AS DECIMAL(10,2)) / NULLIF(COUNT(DISTINCT e.DateFoundJob), 0) AS AvgPlacementsPerDay
FROM dbo.Educator AS e
WHERE e.DateFoundJob IS NOT NULL;

-- Report 5: Placements per day by degree level
SELECT
    e.DateFoundJob,
    CASE
        WHEN e.DegreeTitle LIKE 'BA%' THEN 'Bachelors'
        WHEN e.DegreeTitle LIKE 'MA%' THEN 'Masters'
        WHEN e.DegreeTitle LIKE 'PhD%' THEN 'PhD'
        ELSE 'Other'
    END AS DegreeLevel,
    COUNT(*) AS Placements
FROM dbo.Educator AS e
WHERE e.DateFoundJob IS NOT NULL
GROUP BY
    e.DateFoundJob,
    CASE
        WHEN e.DegreeTitle LIKE 'BA%' THEN 'Bachelors'
        WHEN e.DegreeTitle LIKE 'MA%' THEN 'Masters'
        WHEN e.DegreeTitle LIKE 'PhD%' THEN 'PhD'
        ELSE 'Other'
    END
ORDER BY e.DateFoundJob;

-- Report 6: Educators who reach out (first name, last name, age, degree)
SELECT
    e.FirstName,
    e.LastName,
    DATEDIFF(YEAR, e.DateOfBirth, GETDATE())
        - CASE
            WHEN DATEADD(YEAR, DATEDIFF(YEAR, e.DateOfBirth, GETDATE()), e.DateOfBirth) > GETDATE()
                THEN 1
                ELSE 0
          END AS Age,
    e.DegreeTitle
FROM dbo.Educator AS e
ORDER BY e.LastName, e.FirstName;
