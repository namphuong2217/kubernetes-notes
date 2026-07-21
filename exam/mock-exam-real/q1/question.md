Câu 1 — Reattach an Orphaned PersistentVolume
Đề bài
A user accidentally deleted the Redis Deployment in the redis-store namespace. The Deployment was configured with persistent storage. Your job is to restore the Deployment while ensuring data is preserved by reusing the available PersistentVolume.
Tasks:
Only one PersistentVolume exists in the cluster, currently Released and available for reuse. 	
Create a PersistentVolumeClaim named redis-data in the redis-store namespace with access mode ReadWriteOnce 	and storage request 500Mi.
 	
Edit the Redis Deployment manifest at redis-deploy.yaml to reference the PVC you just created.
 	
Apply the updated manifest.
 	
Confirm the Redis Deployment is running and stable.
Hoặc yêu cầu tạo storage class, config storage class đó thành default storage class sau đó tạo pvc sử dụng sc đó và mount pvc cho pod ⇒ Nằm ở câu 13 rồi.