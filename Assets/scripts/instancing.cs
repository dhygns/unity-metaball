using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class instancing : MonoBehaviour
{

    public GameObject CubeModel;
    public Material CubeMaterial;

    private Vector4 MataPosition1;
    private Vector4 MataPosition2;
    private Vector4 MataPosition3;
    private Vector4 MataPosition4;

    // Use this for initialization
    void Start()
    {
        int range = 10;
        for (int x = -range; x <= range; x++)
        {
            for (int y = -range; y <= range; y++)
            {
                for (int z = -range; z <= range; z++)
                {
                    GameObject obj = Instantiate(CubeModel) as GameObject;
                    obj.transform.SetParent(this.transform);
                    obj.transform.position = new Vector3(x * 0.5f, y * 0.5f, z * 0.5f);
                    obj.transform.localScale = new Vector3(0.5f, 0.5f, 0.5f);
                }
            }
        }


    }

    // Update is called once per frame
    void Update()
    {
        this.MataPosition1.x = 7.0f * Mathf.Sin(Time.time *  1.52f);
        this.MataPosition1.y = 7.0f * Mathf.Sin(Time.time *  1.51f);
        this.MataPosition1.z = 7.0f * Mathf.Sin(Time.time *  0.27f);

        this.MataPosition2.x = 2.0f * Mathf.Sin(Time.time *  3.52f);
        this.MataPosition2.y = 2.0f * Mathf.Sin(Time.time *  0.51f);
        this.MataPosition2.z = 2.0f * Mathf.Sin(Time.time *  2.82f);

        this.MataPosition3.x = 3.0f * Mathf.Sin(Time.time *  3.52f);
        this.MataPosition3.y = 3.0f * Mathf.Sin(Time.time *  0.51f);
        this.MataPosition3.z = 3.0f * Mathf.Sin(Time.time *  1.27f);

        this.MataPosition4.x = 1.0f * Mathf.Sin(Time.time * 1.52f);
        this.MataPosition4.y = 1.0f * Mathf.Sin(Time.time * 1.51f);
        this.MataPosition4.z = 1.0f * Mathf.Sin(Time.time * 4.27f);

        CubeMaterial.SetVector("_MetaPosition1", this.MataPosition1);
        CubeMaterial.SetVector("_MetaPosition2", this.MataPosition2);
        CubeMaterial.SetVector("_MetaPosition3", this.MataPosition3);
        CubeMaterial.SetVector("_MetaPosition4", this.MataPosition4);
    }
}
